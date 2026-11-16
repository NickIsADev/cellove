local BaseTool = require("src/editor/tools/abstract/BaseTool")
local Markers = require("src/engine/simulation/Markers")
local constants = require("src/constants")
local utils = require("src/utils")

local ghost = constants.editor.ghost
local hues = constants.markers.hues

local function matches(a, b)
    if not (a and b) then return a == b end
    return getmetatable(a) == getmetatable(b) and a.rotation == b.rotation and utils.same(a.props, b.props)
end

local Bucket = setmetatable({}, { __index = BaseTool })
Bucket.__index = Bucket

function Bucket.new(editor)
    local self = setmetatable({}, Bucket)
    self:setup(editor, {})
    return self
end

function Bucket:_fill(gx, gy, hue)
    local editor = self.editor
    local function tint(x, y)
        local slot = editor.markers:placeableAt(x, y)
        return slot and Markers.hue(slot)
    end

    local origin = tint(gx, gy)
    for _, point in ipairs(editor.simulator.grid:flood(gx, gy, function(_, x, y) return tint(x, y) == origin end)) do
        editor:setPlaceable(point[1], point[2], hue)
    end
end

function Bucket:press(gx, gy, button)
    local editor = self.editor
    local grid = editor.simulator.grid
    if not grid:bounds(gx, gy) or button == 1 and not editor.selected then return false end

    if button == 1 and editor.selected.tile then
        self:_fill(gx, gy, hues[editor.properties:values(editor.selected).color])
        return false
    end

    local top = grid:top(gx, gy)
    local layer = button == 1 and editor.selected.layer or top and top.layer
    local origin = grid:get(gx, gy, layer)
    local state = button == 1 and {
        class = editor.selected,
        rotation = editor.targetRotation % 4,
        props = editor.properties:values(editor.selected)
    } or nil

    local area = grid:flood(gx, gy, function(cell) return matches(cell, origin) end, layer)
    for _, point in ipairs(area) do
        editor:setCell(point[1], point[2], state, layer)
    end
    return false
end

function Bucket:draw(gx, gy)
    local editor = self.editor
    if not (gx and editor.selected and editor.simulator.grid:bounds(gx, gy)) then return end

    editor.renderer:drawGhost(editor.selected:preview(editor.properties:values(editor.selected)), gx, gy, editor.visualRotation, ghost)
end

return Bucket
