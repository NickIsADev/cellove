local AdjustableResistance = require("content/cells/forces/AdjustableResistance")

local AdjustableConductance = setmetatable({
    name = "adjustableconductance",
    k3 = 1193,
    title = "Adjustable Conductance",
    description = "Blocks only force equal to its numerator divided by its denominator.",
    inverted = true
}, { __index = AdjustableResistance })
AdjustableConductance.__index = AdjustableConductance

return AdjustableConductance
