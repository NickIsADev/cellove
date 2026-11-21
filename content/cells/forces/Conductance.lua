local Resistance = require("content/cells/forces/Resistance")

local Conductance = setmetatable({
    name = "conductance",
    k3 = 1191,
    title = "Conductance",
    description = "Blocks only force of exactly 1 unit.",
    inverted = true
}, { __index = Resistance })
Conductance.__index = Conductance

return Conductance
