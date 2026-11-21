local SuperResistance = require("content/cells/forces/SuperResistance")

local SuperConductance = setmetatable({
    name = "superconductance",
    k3 = 1192,
    title = "Super Conductance",
    description = "Blocks only infinite force.",
    inverted = true
}, { __index = SuperResistance })
SuperConductance.__index = SuperConductance

return SuperConductance
