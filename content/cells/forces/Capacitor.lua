local BaseCoil = require("content/cells/abstract/BaseCoil")
local constants = require("src/constants")

local Capacitor = setmetatable({
    name = "capacitor",
    k3 = 1189,
    title = "Capacitor",
    description = "Lets force through for as many ticks as the amount of force applied to it, then blocks until force is no longer applied to it.",
    properties = { constants.adjustable.count }
}, { __index = BaseCoil })
Capacitor.__index = Capacitor

function Capacitor:_open(amount, fresh)
    if fresh then self.props.count = self.props.count + 1 end
    if self.props.count > amount then return false end

    if fresh then self.props.count = self.props.count + 1 end
    return true
end

return Capacitor
