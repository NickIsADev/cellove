local BaseTool = require("src/editor/tools/abstract/BaseTool")
local constants = require("src/constants")
local utils = require("src/utils")

local ghost = constants.editor.ghost

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

function Bucket:press(gx, gy, button)
    local editor = self.editor
    local grid = editor.simulator.grid
    if not grid:bounds(gx, gy) or button == 1 and not editor.selected then return false end

    local origin = grid:get(gx, gy)
    local state = button == 1 and {
        class = editor.selected,
        rotation = editor.targetRotation % 4,
        props = editor.properties:values(editor.selected)
    } or nil

    local seen, stack = { [gy * grid.width + gx] = true }, { { gx, gy } }
    local function visit(cell, x, y)
        local index = y * grid.width + x
        if seen[index] or not matches(cell, origin) then return end

        seen[index] = true
        stack[#stack + 1] = { x, y }
    end

    while #stack > 0 do
        local point = table.remove(stack)
        editor:setCell(point[1], point[2], state)
        grid:neighbors(point[1], point[2], 1, visit)
    end
    return false
end

function Bucket:draw(gx, gy)
    local editor = self.editor
    if not (gx and editor.selected and editor.simulator.grid:bounds(gx, gy)) then return end

    editor.renderer:drawGhost(editor.selected.texture, gx, gy, editor.visualRotation, ghost)
end

return Bucket
