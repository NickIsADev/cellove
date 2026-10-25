local constants = require("src/constants")
local utils = require("src/utils")

local overlay = constants.debug.world
local tile = constants.grid.tile
local colors = constants.ui.colors

local World = {}
World.__index = World

function World.new(data)
    local self = setmetatable({}, World)
    self.renderer = data.renderer
    return self
end

function World:_drawPath(cell)
    local path = cell.path
    if not path or #path < 2 then return end

    local points = {}
    for _, point in ipairs(path) do
        points[#points + 1] = (point[1] - 0.5) * tile
        points[#points + 1] = (point[2] - 0.5) * tile
    end
    love.graphics.line(points)
end

function World:_drawDetails(simulator, x1, y1, x2, y2)
    local zoom = self.renderer.camera.zoom

    for y = y1, y2 do
        for x = x1, x2 do
            local cell = simulator.grid:get(x, y)

            if zoom >= overlay.zoom.labels then
                love.graphics.setColor(utils.fromHex(colors.white, overlay.alpha.label))
                love.graphics.print(x .. "," .. y, (x - 1) * tile + 2, (y - 1) * tile + 2)
            end

            if cell then
                local facing = constants.directions[cell.rotation]
                local cx, cy = (x - 0.5) * tile, (y - 0.5) * tile
                local tx, ty = cx + facing[1] * tile * overlay.arrow, cy + facing[2] * tile * overlay.arrow

                love.graphics.setColor(utils.fromHex(colors.accent))
                love.graphics.line(cx, cy, tx, ty)
                love.graphics.circle("fill", tx, ty, overlay.tip)
                love.graphics.setColor(utils.fromHex(overlay.path))
                self:_drawPath(cell)
            end
        end
    end

    love.graphics.setColor(utils.fromHex(overlay.path))
    for _, cell in ipairs(simulator.dying) do
        self:_drawPath(cell)
    end
end

function World:draw(simulator)
    local grid, camera = simulator.grid, self.renderer.camera
    local w, h = love.graphics.getDimensions()
    local x1, y1 = camera:screenToGrid(0, 0)
    local x2, y2 = camera:screenToGrid(w, h)
    local hx, hy = camera:screenToGrid(love.mouse.getPosition())
    x1, y1, x2, y2 = math.max(1, x1), math.max(1, y1), math.min(grid.width, x2), math.min(grid.height, y2)

    local previousFont = love.graphics.getFont()

    love.graphics.push()
    camera:apply()
    love.graphics.setFont(self.renderer:font(overlay.font))
    love.graphics.setLineWidth(overlay.width / camera.zoom)

    if camera.zoom >= overlay.zoom.grid then
        love.graphics.setColor(utils.fromHex(colors.white, overlay.alpha.grid))
        for x = x1, x2 + 1 do
            love.graphics.line((x - 1) * tile, (y1 - 1) * tile, (x - 1) * tile, y2 * tile)
        end
        for y = y1, y2 + 1 do
            love.graphics.line((x1 - 1) * tile, (y - 1) * tile, x2 * tile, (y - 1) * tile)
        end
    end

    love.graphics.setColor(utils.fromHex(colors.accent, overlay.alpha.bounds))
    love.graphics.rectangle("line", 0, 0, grid.width * tile, grid.height * tile)

    if camera.zoom >= overlay.zoom.arrows then self:_drawDetails(simulator, x1, y1, x2, y2) end

    if grid:bounds(hx, hy) then
        love.graphics.setColor(utils.fromHex(colors.white, overlay.alpha.hover))
        love.graphics.rectangle("fill", (hx - 1) * tile, (hy - 1) * tile, tile, tile)
    end

    local cross = overlay.cross / camera.zoom
    love.graphics.setColor(utils.fromHex(colors.danger))
    love.graphics.line(camera.x - cross, camera.y, camera.x + cross, camera.y)
    love.graphics.line(camera.x, camera.y - cross, camera.x, camera.y + cross)

    love.graphics.pop()
    love.graphics.setFont(previousFont)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return World
