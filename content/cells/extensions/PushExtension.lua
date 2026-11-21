local BaseExtension = require("content/cells/abstract/BaseExtension")
local constants = require("src/constants")

local PushExtension = setmetatable({
    name = "pushextension",
    k3 = 466,
    title = "Push Extension",
    description = "When moved by any force, it extends that force: it pushes forward in the direction it moved."
}, { __index = BaseExtension })
PushExtension.__index = PushExtension

function PushExtension:_extend(dx, dy)
    self:push(dx, dy, constants.force.strength)
end

function PushExtension:chained(action, dx, dy)
    if action ~= "grab" then return end

    local movement, x, y = self.simulator.movement, self.x, self.y
    movement:post(function() movement:push(x, y, dx, dy, constants.force.unit) end)
end

return PushExtension
