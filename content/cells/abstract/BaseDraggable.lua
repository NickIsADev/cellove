local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local function drag(cell, dx, dy)
    if (dx ~= 0 or dy ~= 0) and cell.grid:get(cell.x, cell.y) == cell and cell:pushable(dx, dy) then
        cell:push(dx, dy, constants.force.strength)
    end
end

local BaseDraggable = setmetatable({}, { __index = BaseCell })
BaseDraggable.__index = BaseDraggable

function BaseDraggable:click(button)
    if button ~= 1 then return false end

    self.simulator.drag = self
    return true
end

function BaseDraggable:update()
    local simulator = self.simulator
    if simulator.drag ~= self then return end

    local cursor = simulator.cursor
    drag(self, utils.sign(cursor.x - self.x), 0)
    drag(self, 0, utils.sign(cursor.y - self.y))
end

return BaseDraggable
