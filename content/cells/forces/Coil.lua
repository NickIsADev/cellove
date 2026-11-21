local BaseCoil = require("content/cells/abstract/BaseCoil")
local constants = require("src/constants")

local Coil = setmetatable({
    name = "coil",
    k3 = 1187,
    title = "Coil",
    description = "Blocks force for as many ticks as the amount of force applied to it, then lets everything pass.",
    properties = { constants.adjustable.count }
}, { __index = BaseCoil })
Coil.__index = Coil

function Coil:_open(amount, fresh)
    if fresh then self.props.count = self.props.count + 1 end
    if self.props.count > amount then return true end

    if fresh then self.props.count = self.props.count + 1 end
    return false
end

return Coil
