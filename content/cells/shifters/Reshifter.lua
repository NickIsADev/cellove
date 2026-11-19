local Shifter = require("content/cells/shifters/Shifter")

local Reshifter = setmetatable({
    name = "reshifter",
    k3 = 1152,
    title = "Reshifter",
    description = "Shifter that flips around when it has nothing to shift.",
    reverses = true
}, { __index = Shifter })
Reshifter.__index = Reshifter

return Reshifter
