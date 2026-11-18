local Shifter = require("content/cells/shifters/Shifter")

local CrossShifter = setmetatable({
    name = "crossshifter",
    k3 = 107,
    title = "Cross Shifter",
    description = "Two Shifters combined.",
    outputs = { 0, 3 }
}, { __index = Shifter })
CrossShifter.__index = CrossShifter

return CrossShifter
