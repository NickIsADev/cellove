local Capacitor = require("content/cells/forces/Capacitor")
local constants = require("src/constants")

local AdjustableCapacitor = setmetatable({
    name = "adjustablecapacitor",
    k3 = 1190,
    title = "Adjustable Capacitor",
    description = "Capacitor that uses its own amount instead of the amount of force applied.",
    properties = { constants.adjustable.count, constants.adjustable.amount }
}, { __index = Capacitor })
AdjustableCapacitor.__index = AdjustableCapacitor

function AdjustableCapacitor:_label()
    return self.props.count .. "/" .. self.props.amount
end

return AdjustableCapacitor
