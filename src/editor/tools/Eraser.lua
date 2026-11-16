local Brush = require("src/editor/tools/Brush")
local constants = require("src/constants")

local config = constants.editor.brush
local colors = constants.ui.colors

local Eraser = setmetatable({}, { __index = Brush })
Eraser.__index = Eraser

function Eraser.new(editor)
    local self = setmetatable({}, Eraser)
    self:setup(editor, config.buttons)
    self:reset()
    return self
end

function Eraser:_paint(gx, gy)
    local editor = self.editor
    local grid, markers = editor.simulator.grid, editor.markers

    for _, point in ipairs(self.points) do
        local x, y = gx + point[1], gy + point[2]
        local top = grid:top(x, y)

        if top then
            editor:setCell(x, y, nil, top.layer)
        elseif markers:at(x, y) then
            editor:setMarker(x, y)
        elseif markers:placeableAt(x, y) then
            editor:setPlaceable(x, y, false)
        elseif markers:boxAt(x, y) then
            editor:removeArea(markers:boxAt(x, y))
        end
    end
end

function Eraser:press(gx, gy)
    self.x, self.y = gx, gy
    self:_paint(gx, gy)
    return true
end

function Eraser:draw(gx, gy)
    local editor = self.editor
    if not gx then return end

    for _, point in ipairs(self.points) do
        local x, y = gx + point[1], gy + point[2]
        if editor.simulator.grid:bounds(x, y) then editor.renderer:drawBox(x, y, x, y, colors.danger) end
    end
end

return Eraser
