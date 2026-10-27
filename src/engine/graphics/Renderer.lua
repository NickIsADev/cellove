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
local flat = constants.renderer.flat
local clear = constants.renderer.clear
local tag = constants.renderer.tag
local tile = constants.grid.tile
local colors = constants.ui.colors
local stride = 6
local weak = { __mode = "k" }

local names = setmetatable({}, {
    __index = function(cache, kind)
        cache[kind] = utils.texture(kind)
        return cache[kind]
    end
})

local function push(list, cell, x, y, angle, size, fade)
    local n = list.n
    list[n + 1], list[n + 2], list[n + 3], list[n + 4], list[n + 5], list[n + 6] = cell, x, y, angle, size, fade
    list.n = n + stride
end

local function append(list, other)
    for i = 1, other.n do
        list[list.n + i] = other[i]
    end
    list.n = list.n + other.n
end

local function paint(data, x, y, tint)
    data:setPixel(x, y, tint[1], tint[2], tint[3], tint[4])
end

local function place(batch, size, x, y)
    batch:add((x - 0.5) * tile, (y - 0.5) * tile, 0, size.scale, size.scale, size.x, size.y)
end

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(data)
    local self = setmetatable({}, Renderer)
    self.texturePacks = data.texturePacks
    self.particles = Particles.new()
    self.shadows = true
    self.animated = true
    self.queue = { n = 0 }
    self.rest = { n = 0 }
    self.tail = { n = 0 }
    self.cache = {}
    self.profile = { collect = 0, layer = 0 }
    self.labels = setmetatable({}, weak)
    self.shadowShader = love.graphics.newShader(shadow.shader)
    self.backgroundQuad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)
    self.camera = Camera.new({ hotkeys = data.hotkeys })

    data.settings:listen("packs", function() self:loadTextures() end)
    data.settings:listen("uiScale", function() self.fonts = {} end)
    data.settings:listen("cellShadows", function(enabled) self.shadows = enabled end)
    data.settings:listen("explosions", function(enabled) self.particles.enabled = enabled end)
    data.settings:listen("animatedBackground", function(enabled) self.scrolling = enabled end)
    data.settings:listen("detailZoom", function(percent) self.far = percent / 100 end)
    data.settings:listen("cellAnimation", function(enabled) self.animated = enabled end)
    return self
end

function Renderer:_path(folder, file)
    return self.texturePacks:find(folder, file)
end

function Renderer:_image(folder, name)
    return self:_path(folder, name .. ".png") or self:_path(config.missing.folder, config.missing.name .. ".png")
end

function Renderer:_textures(folder)
    return setmetatable({}, {
        __index = function(cache, name)
            local image = love.graphics.newImage(self:_image(folder, name))
            local width, height = image:getDimensions()

            self.sizes[image] = {
                scale = tile / width,
                x = width / 2,
                y = height / 2
            }
            cache[name] = image
            return image
        end
    })
end

function Renderer:_sprite(name)
    local texture = self.textures.cells[name]
    return texture, self.sizes[texture]
end

function Renderer:_average(folder, name)
    local data = love.image.newImageData(self:_image(folder, name))
    local width, height = data:getDimensions()
    local r, g, b, a = 0, 0, 0, 0

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pr, pg, pb, pa = data:getPixel(x, y)
            r, g, b, a = r + pr * pa, g + pg * pa, b + pb * pa, a + pa
        end
    end

    return a > 0 and { r / a, g / a, b / a, a / (width * height) } or clear
end

function Renderer:_tint(name)
    local tint = self.tints[name] or self:_average("cells", name)
    self.tints[name] = tint
    return tint
end

function Renderer:_queue(list, cell, x, y, progress, dying)
    local size, fade = 1, 0
    if cell.grow then size = utils.lerp(cell.grow, 1, progress) end

    local path = cell.path
    if path and #path > 1 then
        if (cell.own or 0) > 1 then
            local t = progress * (#path - 1)
            local i = math.min(math.floor(t), #path - 2)
            local a, b = path[i + 1], path[i + 2]
            x = utils.lerp(a[1], b[1], t - i)
            y = utils.lerp(a[2], b[2], t - i)
            if dying then size = 1 - math.max(0, t - (#path - 2)) end
        else
            local a, b = path[1], path[#path]
            x = utils.lerp(a[1], b[1], progress)
            y = utils.lerp(a[2], b[2], progress)
            if dying then size = 1 - progress end
        end
    end

    if cell.exploded then
        fade = self.particles:blast(cell, progress)
        if fade >= 1 then return end
        size = 1 + fade * blast.grow
    end

    push(list, cell, x, y, cell.rotation - (cell.turn or 0) * (1 - progress), size, fade)
end

function Renderer:_collect(simulator, progress)
    local queue, rest, tail = self.queue, self.rest, self.tail
    local grid, camera = simulator.grid, self.camera
    local cells, width = grid.cells, grid.width
    queue.n, rest.n, tail.n = 0, 0, 0

    local margin = simulator.maxSubticks
    local halfWidth = love.graphics.getWidth() / 2 / camera.zoom
    local halfHeight = love.graphics.getHeight() / 2 / camera.zoom
    local minX = math.max(1, math.floor((camera.x - halfWidth) / tile) + 1 - margin)
    local maxX = math.min(grid.width, math.floor((camera.x + halfWidth) / tile) + 1 + margin)
    local minY = math.max(1, math.floor((camera.y - halfHeight) / tile) + 1 - margin)
    local maxY = math.min(grid.height, math.floor((camera.y + halfHeight) / tile) + 1 + margin)

    for _, cell in ipairs(simulator.dying) do
        local visible = cell.x >= minX and cell.x <= maxX and cell.y >= minY and cell.y <= maxY
        if visible then self:_queue(cell.born and tail or queue, cell, cell.x, cell.y, progress, true) end
    end

    for y = minY, maxY do
        local row = (y - 1) * width
        for x = minX, maxX do
            local cell = cells[row + x]
            if cell then self:_queue(cell.born and queue or rest, cell, x, y, progress, false) end
        end
    end

    append(queue, rest)
    append(queue, tail)
end

function Renderer:_drawCells(offset)
    local queue = self.queue

    for i = 1, queue.n, stride do
        local cell, x, y, angle, size, fade = queue[i], queue[i + 1], queue[i + 2], queue[i + 3], queue[i + 4], queue[i + 5]

        if fade == 0 then
            cell:draw(self, x, y, angle, size, offset)
        else
            local r, g, b, a = love.graphics.getColor()

            love.graphics.setColor(r, g, b, a * (1 - fade))
            cell:draw(self, x, y, angle, size, offset)
            love.graphics.setColor(r, g, b, a)
        end
    end
end

function Renderer:_fitBackground(grid)
    local back = self.back
    if back.cols == grid.width and back.rows == grid.height then return end

    back.cols, back.rows = grid.width, grid.height
    self.backgroundQuad:setViewport(0, 0, grid.width * back.width, grid.height * back.height, back.width, back.height)
end

function Renderer:_drawBorder(grid)
    local border = self.border

    if border.cols ~= grid.width or border.rows ~= grid.height then
        local size = self.sizes[self.textures.cells.ghost]
        local right, bottom = grid.width + 1, grid.height + 1

        border.cols, border.rows = grid.width, grid.height
        border.batch:clear()
        for x = 0, right do
            place(border.batch, size, x, 0)
            place(border.batch, size, x, bottom)
        end
        for y = 1, grid.height do
            place(border.batch, size, 0, y)
            place(border.batch, size, right, y)
        end
    end

    love.graphics.draw(border.batch)
end

function Renderer:_drawTile(name, x, y)
    local texture = self.textures.ui[name]
    local scale = self.sizes[texture].scale

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

function Renderer:_label(item, color, alpha)
    local label = self.labels[item]
    if label and label.text == item.text and label.color == color and label.alpha == alpha then return label end

    label = {
        text = item.text,
        color = color,
        alpha = alpha,
        plain = utils.plain(item.text),
        colored = utils.colored(item.text, { utils.fromHex(color, alpha) }, alpha)
    }
    self.labels[item] = label
    return label
end

function Renderer:_drawLayer(simulator, progress)
    local profile, start = self.profile, love.timer.getTime()

    self:_collect(simulator, progress)
    profile.collect = (love.timer.getTime() - start) * 1000

    if self.shadows and self.camera.zoom >= self.far then
        love.graphics.setShader(self.shadowShader)
        love.graphics.setColor(utils.fromHex(0x000000, shadow.alpha))
        self:_drawCells(shadow.offset)
        love.graphics.setShader()
        love.graphics.setColor(utils.fromHex(colors.white))
    end
    self:_drawBorder(simulator.grid)
    self:_drawCells(0)
    profile.layer = (love.timer.getTime() - start) * 1000
end

function Renderer:_drawFlat(grid)
    local map = self.map
    local width, height = grid.width, grid.height

    if map.grid ~= grid or map.width ~= width or map.height ~= height then
        local border = self:_tint("ghost")

        map.data = love.image.newImageData(width + 2, height + 2)
        for x = 0, width + 1 do
            paint(map.data, x, 0, border)
            paint(map.data, x, height + 1, border)
        end
        for y = 1, height do
            paint(map.data, 0, y, border)
            paint(map.data, width + 1, y, border)
        end

        map.image = love.graphics.newImage(map.data)
        map.image:setFilter("nearest", "nearest")
        map.grid, map.width, map.height, map.version, map.last = grid, width, height, nil, {}
    end

    if map.version ~= grid.version then
        local data, last = map.data, map.last

        for i = 1, width * height do
            local cell = grid.cells[i]
            local tint = cell and self:_tint(getmetatable(cell).texture) or clear

            if last[i] ~= tint then
                last[i] = tint
                paint(data, (i - 1) % width + 1, math.floor((i - 1) / width) + 1, tint)
            end
        end

        map.image:replacePixels(data)
        map.version = grid.version
    end

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(map.image, -tile, -tile, 0, tile, tile)
end

function Renderer:_drawFar(simulator, progress)
    local cache, grid, camera = self.cache, simulator.grid, self.camera
    local width, height = Display.size()
    local key = table.concat({ tostring(grid), grid.version, camera.x, camera.y, camera.zoom, Display.scale, width, height }, ",")

    if cache.width ~= width or cache.height ~= height then
        cache.canvas = love.graphics.newCanvas(width, height)
        cache.width, cache.height, cache.key = width, height, nil
    end

    if cache.key ~= key or #self.particles.blasts > 0 then
        local previous = love.graphics.getCanvas()

        love.graphics.setCanvas(cache.canvas)
        love.graphics.clear(0, 0, 0, 0)
        self:_drawLayer(simulator, progress)
        love.graphics.setCanvas(previous)
        cache.key = key
    end

    love.graphics.push()
    love.graphics.origin()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(cache.canvas)
    love.graphics.setBlendMode("alpha")
    love.graphics.pop()
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
    local texture, size = self:_sprite(name)
    local factor = size.scale * scale

    love.graphics.draw(texture, (x - 0.5) * tile + offset, (y - 0.5) * tile + offset,
        angle * math.pi / 2, factor, factor, size.x, size.y)
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

function Renderer:drawStored(content, x, y, turn, scale, offset)
    if offset ~= 0 then return end

    self:drawSprite(content.class.texture, x, y, content.rotation + turn, scale, 0)
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
            local label = self:_label(item, color, alpha)
            local left, top = x - font:getWidth(label.plain) / 2, y - font:getHeight() / 2

            love.graphics.setColor(utils.fromHex(0x000000, mark.shadow.alpha * alpha))
            love.graphics.print(label.plain, left + mark.shadow.offset, top + mark.shadow.offset)
            love.graphics.setColor(utils.fromHex(colors.white))
            love.graphics.print(label.colored, left, top)
        elseif item.kind ~= "placeable" then
            local texture = self.textures.markers[names[item.kind]]
            local size = self.sizes[texture]

            love.graphics.setColor(utils.fromHex(colors.white, alpha))
            love.graphics.draw(texture, x, y, (item.rotation or 0) * math.pi / 2, size.scale, size.scale, size.x, size.y)
        end
    end

    love.graphics.pop()
    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Renderer:loadTextures()
    self.sizes = setmetatable({}, weak)
    self.fonts = {}
    self.textures = {
        cells = self:_textures("cells"),
        ui = self:_textures("ui"),
        markers = self:_textures("markers")
    }

    local background = self.textures.ui.background
    local width, height = background:getDimensions()
    background:setWrap("repeat", "repeat")

    self.back = {
        texture = background,
        width = width,
        height = height,
        tint = self:_average("ui", "background"),
        cols = 0,
        rows = 0
    }
    self.border = {
        batch = love.graphics.newSpriteBatch(self.textures.cells.ghost),
        cols = 0,
        rows = 0
    }

    self.tints = {}
    self.map = {}
    self.cache.key = nil
    if self.classes then self:preload(self.classes) end
end

function Renderer:preload(classes, first, last)
    self.classes = classes
    for i = first or 1, last or #classes do
        self:_sprite(classes[i].texture)
    end
end

function Renderer:draw(simulator, progress, markers)
    local grid, back = simulator.grid, self.back
    local distant, minimal = self.camera.zoom < self.far, self.camera.zoom < flat

    if distant or not self.animated then progress = 1 end

    love.graphics.clear(utils.fromHex(colors.dark))
    love.graphics.push()
    love.graphics.origin()
    love.graphics.scale(Display.scale)
    self.camera:apply()

    love.graphics.setColor(utils.fromHex(colors.dark))
    love.graphics.rectangle("fill", 0, 0, grid.width * tile, grid.height * tile)

    if minimal then
        love.graphics.setColor(back.tint)
        love.graphics.rectangle("fill", 0, 0, grid.width * tile, grid.height * tile)
    else
        self:_fitBackground(grid)
        love.graphics.setColor(utils.fromHex(colors.white))
        love.graphics.draw(back.texture, self.backgroundQuad, 0, 0, 0, tile / back.width, tile / back.height)
    end

    self:_drawPlaceables(markers)
    if minimal then
        self:_drawFlat(grid)
    elseif distant then
        self:_drawFar(simulator, progress)
    else
        self:_drawLayer(simulator, progress)
    end
    if not simulator:started() then self:_drawOverlays(markers, grid) end
    self.particles:draw()

    love.graphics.pop()
end

return Renderer
