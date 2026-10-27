local BaseHolder = require("content/cells/abstract/BaseHolder")

local BaseConverter = setmetatable({}, { __index = BaseHolder })
BaseConverter.__index = BaseConverter

function BaseConverter:_convert()
    self:_release(self.rotation)
end

function BaseConverter:eats(dx, dy)
    return self:_alignment(dx, dy) > 0
end

function BaseConverter:absorb(cell)
    if self:held() then
        self.simulator.movement:defer(function() self:_convert() end)
    else
        BaseHolder.absorb(self, cell)
    end
end

return BaseConverter
