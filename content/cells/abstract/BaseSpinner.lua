local Wall = require("content/cells/walls/Wall")

local BaseSpinner = setmetatable({
    categories = { "walls", "otherrotators" },
    spin = 1
}, { __index = Wall })
BaseSpinner.__index = BaseSpinner

function BaseSpinner:_spin(cell, dx, dy)
    cell:rotate(self.spin, { dx = dx, dy = dy })
end

function BaseSpinner:bumped(dx, dy, pusher)
    if pusher then self:_spin(pusher, dx, dy) end
end

return BaseSpinner
