local Tentative = require("content/cells/forces/Tentative")

local Inhibation = setmetatable({
    name = "inhibation",
    k3 = 1195,
    title = "Inhibation",
    description = "Blocks only force equal to its rotation plus 1 units.",
    inverted = true
}, { __index = Tentative })
Inhibation.__index = Inhibation

return Inhibation
