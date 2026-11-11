local Trash = require("content/cells/destroyers/Trash")
local constants = require("src/constants")
local utils = require("src/utils")

local BaseReactiveTrash = setmetatable({}, { __index = Trash })
BaseReactiveTrash.__index = BaseReactiveTrash

function BaseReactiveTrash:_heading(dx, dy)
    if not self.veer then return self:_aim() end

    return utils.turn(dx, dy, self.veer)
end

function BaseReactiveTrash:_react(dx, dy)
    if self.physical then
        self.simulator.movement:repel(self.x, self.y, dx, dy)
    else
        self:push(dx, dy, constants.force.strength)
    end
end

function BaseReactiveTrash:absorb(_, dx, dy)
    dx, dy = self:_heading(dx, dy)
    self.simulator.movement:defer(function() self:_react(dx, dy) end)
end

return BaseReactiveTrash
