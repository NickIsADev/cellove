local constants = require("src/constants")
local Display = require("src/engine/graphics/Display")
local Camera = require("src/engine/graphics/Camera")
local Particles = require("src/engine/graphics/Particles")
local utils = require("src/utils")

local config = constants.texturepacks
local shadow = constants.renderer.shadow
local box = constants.renderer.box
local mark = constants.renderer.marker
local blast = constants.renderer.explosion
local tag = constants.renderer.tag
local tile = constants.grid.tile
local colors = constants.ui.colors

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(data)
    local self = setmetatable({}, Renderer)
    self.texturePacks = data.texturePacks
    self.particles = Particles.new()
    self.shadows = true
    self.animated = true
    self.canvas = love.graphics.newCanvas(Display.size())
    self.shadowShader = love.graphics.newShader(shadow.shader)
    self.backgroundQuad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)
    self.camera = Camera.new()

    data.settings:listen("packs", function() self:loadTextures() end)
    data.settings:listen("uiScale", function() self.fonts = {} end)
    data.settings:listen("cellShadows", function(enabled) self.shadows = enabled end)
    data.settings:listen("cellAnimation", function(enabled) self.animated = enabled end)
    return self
end

function Renderer:_path(folder, file)
    return self.texturePacks:find(folder, file)
end

function Renderer:_textures(folder)
    return setmetatable({}, {
        __index = function(cache, name)
            local path = self:_path(folder, name .. ".png") or self:_path(config.missing.folder, config.missing.name .. ".png")
            cache[name] = love.graphics.newImage(path)
            return cache[name]
        end
    })
end

function Renderer:_drawCell(cell, x, y, progress, dying, offset)
    local rx, ry, size = x, y, 1

    local path = cell.path
    if path and #path > 1 then
        local own = 0
        for i = 2, #path do
            if path[i][3] then own = own + 1 end
        end

        if own > 1 then
            local t = progress * (#path - 1)
            local i = math.min(math.floor(t), #path - 2)
            local a, b = path[i + 1], path[i + 2]
            rx = utils.lerp(a[1], b[1], t - i)
            ry = utils.lerp(a[2], b[2], t - i)
            if dying then size = 1 - math.max(0, t - (#path - 2)) end
        else
            local a, b = path[1], path[#path]
            rx = utils.lerp(a[1], b[1], progress)
            ry = utils.lerp(a[2], b[2], progress)
            if dying then size = 1 - progress end
        end
    end

    local angle = cell.rotation - (cell.turn or 0) * (1 - progress)

    if cell.exploded then
        local t = self.particles:blast(cell, progress)
        if t >= 1 then return end

        local r, g, b, a = love.graphics.getColor()

        love.graphics.setColor(r, g, b, a * (1 - t))
        cell:draw(self, rx, ry, angle, 1 + t * blast.grow, offset)
        love.graphics.setColor(r, g, b, a)
        return
    end

    cell:draw(self, rx, ry, angle, size, offset)
end

function Renderer:_drawBorder(grid)
    local right, bottom = grid.width + 1, grid.height + 1

    for x = 0, right do
        self:drawSprite("ghost", x, 0, 0, 1, 0)
        self:drawSprite("ghost", x, bottom, 0, 1, 0)
    end
    for y = 1, grid.height do
        self:drawSprite("ghost", 0, y, 0, 1, 0)
        self:drawSprite("ghost", right, y, 0, 1, 0)
    end
end

function Renderer:_drawTile(name, x, y)
    local texture = self.textures.ui[name]
    local scale = tile / texture:getWidth()

    love.graphics.draw(texture, (x - 1) * tile, (y - 1) * tile, 0, scale, scale)
end

function Renderer:_eachSlot(markers, visit)
    for _, marker in ipairs(markers) do
        if marker.kind == "placeable" then visit(marker.x, marker.y) end
    end
end

function Renderer:_drawPlaceables(markers)
    self:_eachSlot(markers, function(x, y)
        love.graphics.setColor(utils.fromHex(colors.dark))
        love.graphics.rectangle("fill", (x - 1) * tile, (y - 1) * tile, tile, tile)
        love.graphics.setColor(utils.fromHex(colors.white))
        self:_drawTile("placeable", x, y)
    end)
end

function Renderer:_drawOverlays(markers, grid)
    self:_eachSlot(markers, function(x, y)
        if grid:get(x, y) then self:_drawTile("placeable_overlay", x, y) end
    end)
end

function Renderer:_eachCell(simulator, visit)
    for _, cell in ipairs(simulator.dying) do
        if not cell.born then visit(cell, cell.x, cell.y, true) end
    end

    local camera = self.camera
    local margin = simulator.maxSubticks
    local halfWidth = love.graphics.getWidth() / 2 / camera.zoom
    local halfHeight = love.graphics.getHeight() / 2 / camera.zoom
    local minX = math.max(1, math.floor((camera.x - halfWidth) / tile) + 1 - margin)
    local maxX = math.min(simulator.grid.width, math.floor((camera.x + halfWidth) / tile) + 1 + margin)
    local minY = math.max(1, math.floor((camera.y - halfHeight) / tile) + 1 - margin)
    local maxY = math.min(simulator.grid.height, math.floor((camera.y + halfHeight) / tile) + 1 + margin)

    for pass = 1, 2 do
        for y = minY, maxY do
            for x = minX, maxX do
                local cell = simulator.grid:get(x, y)
                if cell and (cell.born ~= nil) == (pass == 1) then
                    visit(cell, x, y, false)
                end
            end
        end
    end

    for _, cell in ipairs(simulator.dying) do
        if cell.born then visit(cell, cell.x, cell.y, true) end
    end
end

function Renderer:_drawCells(simulator, progress, offset)
    self:_eachCell(simulator, function(cell, x, y, dying)
        self:_drawCell(cell, x, y, progress, dying, offset)
    end)
end

function Renderer:font(size)
    local font = self.fonts[size]
    if not font then
        font = love.graphics.newFont(self:_path("font", "regular.ttf"), size, "normal", Display.dpi())
        font:setFilter("nearest", "nearest")
        self.fonts[size] = font
    end
    return font
end

function Renderer:drawSprite(name, x, y, angle, scale, offset)
    local texture = self.textures.cells[name]
    local width, height = texture:getDimensions()
    local factor = tile / width * scale

    love.graphics.draw(texture, (x - 0.5) * tile + offset, (y - 0.5) * tile + offset,
        angle * math.pi / 2, factor, factor, width / 2, height / 2)
end

function Renderer:drawTag(text, x, y, _, scale, offset)
    if offset ~= 0 then return end

    text = tostring(text)
    local size = math.max(1, math.floor(tag.font * self.camera.zoom + 0.5))
    local font = self:font(size)
    local unit = scale * tag.font / size
    local previousFont = love.graphics.getFont()
    local r, g, b, a = love.graphics.getColor()
    local margin, shadow = tag.margin * scale, tag.shadow.offset * unit
    local right, bottom = (x - 0.5 + scale / 2) * tile - margin, (y - 0.5 + scale / 2) * tile - margin
    local width, height = font:getWidth(text), font:getBaseline()

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(0x000000, tag.shadow.alpha * a))
    love.graphics.print(text, right + shadow, bottom + shadow, 0, unit, unit, width, height)
    love.graphics.setColor(r, g, b, a)
    love.graphics.print(text, right, bottom, 0, unit, unit, width, height)
    love.graphics.setFont(previousFont)
end

function Renderer:drawGhost(name, gx, gy, rotation, alpha)
    love.graphics.push()
    self.camera:apply()

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    self:drawSprite(name, gx, gy, rotation, 1, 0)

    love.graphics.pop()
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Renderer:drawGhosts(cells, ox, oy, alpha)
    love.graphics.push()
    self.camera:apply()

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    for _, cell in ipairs(cells) do
        self:drawSprite(cell.class.texture, cell.x + ox, cell.y + oy, cell.rotation, 1, 0)
    end

    love.graphics.pop()
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Renderer:drawBox(x1, y1, x2, y2, color)
    local x, y = (x1 - 1) * tile, (y1 - 1) * tile
    local width, height = (x2 - x1 + 1) * tile, (y2 - y1 + 1) * tile

    love.graphics.push()
    self.camera:apply()

    love.graphics.setColor(utils.fromHex(color, box.fill))
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(utils.fromHex(color, box.line))
    love.graphics.setLineWidth(box.width / self.camera.zoom)
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setLineWidth(1)

    love.graphics.pop()
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Renderer:drawMarkers(markers, alpha, ox, oy)
    alpha, ox, oy = alpha or 1, ox or 0, oy or 0

    local font = self:font(mark.font)
    local previousFont = love.graphics.getFont()

    love.graphics.push()
    self.camera:apply()
    love.graphics.setFont(font)

    for _, item in ipairs(markers) do
        local x, y = (item.x + ox - 0.5) * tile, (item.y + oy - 0.5) * tile
        local color = item.color or colors.white

        if item.kind == "box" then
            love.graphics.setColor(utils.fromHex(color, mark.box.alpha * alpha))
            love.graphics.setLineWidth(mark.box.width / self.camera.zoom)
            love.graphics.rectangle("line", (item.x + ox - 1) * tile, (item.y + oy - 1) * tile,
                item.width * tile, item.height * tile)
            love.graphics.setLineWidth(1)
        elseif item.kind == "label" then
            local plain = utils.plain(item.text)
            local left, top = x - font:getWidth(plain) / 2, y - font:getHeight() / 2

            love.graphics.setColor(utils.fromHex(0x000000, mark.shadow.alpha * alpha))
            love.graphics.print(plain, left + mark.shadow.offset, top + mark.shadow.offset)
            love.graphics.setColor(utils.fromHex(colors.white))
            love.graphics.print(utils.colored(item.text, { utils.fromHex(color, alpha) }, alpha), left, top)
        elseif item.kind ~= "placeable" then
            local texture = self.textures.markers[utils.texture(item.kind)]
            local width, height = texture:getDimensions()
            local scale = tile / width

            love.graphics.setColor(utils.fromHex(colors.white, alpha))
            love.graphics.draw(texture, x, y, (item.rotation or 0) * math.pi / 2, scale, scale, width / 2, height / 2)
        end
    end

    love.graphics.pop()
    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Renderer:loadTextures()
    self.textures = {
        cells = self:_textures("cells"),
        ui = self:_textures("ui"),
        markers = self:_textures("markers")
    }
    self.fonts = {}
end

function Renderer:draw(simulator, progress, markers)
    if not self.animated then progress = 1 end

    local w, h = Display.size()
    if w ~= self.canvas:getWidth() or h ~= self.canvas:getHeight() then
        self.canvas:release()
        self.canvas = love.graphics.newCanvas(w, h)
    end

    local grid = simulator.grid
    local background = self.textures.ui.background
    local tileWidth, tileHeight = background:getDimensions()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(utils.fromHex(colors.dark))
    love.graphics.push()
    love.graphics.origin()
    love.graphics.scale(Display.scale)
    self.camera:apply()

    love.graphics.setColor(utils.fromHex(colors.dark))
    love.graphics.rectangle("fill", 0, 0, grid.width * tile, grid.height * tile)

    background:setWrap("repeat", "repeat")
    self.backgroundQuad:setViewport(0, 0, grid.width * tileWidth, grid.height * tileHeight, tileWidth, tileHeight)

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(background, self.backgroundQuad, 0, 0, 0, tile / tileWidth, tile / tileHeight)

    self:_drawPlaceables(markers)
    
    if self.shadows then
        love.graphics.setShader(self.shadowShader)
        love.graphics.setColor(utils.fromHex(0x000000, shadow.alpha))
        self:_drawCells(simulator, progress, shadow.offset)
        love.graphics.setShader()
        love.graphics.setColor(utils.fromHex(colors.white))
    end
    self:_drawBorder(grid)
    self:_drawCells(simulator, progress, 0)
    if not simulator:started() then self:_drawOverlays(markers, grid) end
    self.particles:draw()

    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.clear(utils.fromHex(colors.dark))
    love.graphics.push()
    love.graphics.origin()
    love.graphics.draw(self.canvas)
    love.graphics.pop()
end

return Renderer
