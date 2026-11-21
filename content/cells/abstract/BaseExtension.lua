local BaseCell = require("content/cells/abstract/BaseCell")

local BaseExtension = setmetatable({
    categories = { "extensions" }
}, { __index = BaseCell })
BaseExtension.__index = BaseExtension

function BaseExtension:pushed(dx, dy, action)
    if action == "push" then return end

    self.simulator.movement:defer(function()
        if self.grid:get(self.x, self.y) == self then self:_extend(dx, dy) end
    end)
end

return BaseExtension
