local Wall = require("content/cells/walls/Wall")

local BaseSpinner = setmetatable({
    categories = { "walls", "otherrotators" },
    spin = 1
}, { __index = Wall })
BaseSpinner.__index = BaseSpinner

function BaseSpinner:_spin(cell)
    cell:rotate(self.spin)
end

function BaseSpinner:bump(_, _, pusher)
    if pusher then self:_spin(pusher) end
end

return BaseSpinner
