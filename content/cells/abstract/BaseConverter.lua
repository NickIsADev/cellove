local BaseHolder = require("content/cells/abstract/BaseHolder")
local constants = require("src/constants")

local BaseConverter = setmetatable({}, { __index = BaseHolder })
BaseConverter.__index = BaseConverter

function BaseConverter:_convert()
    self:_release(self.rotation, "eject")
end

function BaseConverter:_ready()
    return self:held()
end

function BaseConverter:_emit()
    self.simulator.movement:defer(function() self:_convert() end)
end

function BaseConverter:bump(dx, dy)
    if self:held() and self:_alignment(dx, dy) > 0 then self:_emit() end
end

function BaseConverter:eats(dx, dy, action)
    if not ((dx == 0 or dy == 0) and self:_alignment(dx, dy) > 0) then return false end
    if action ~= nil or not self:_ready() then return true end

    local facing = constants.directions[self.rotation]
    return self.grid.simulator.movement:clear(self.x, self.y, facing[1], facing[2])
end

function BaseConverter:absorb(cell, dx, dy, action)
    if action == "swap" then return end

    if self:held() then
        self:_emit()
    else
        BaseHolder.absorb(self, cell)
    end
end

return BaseConverter
