local Shifter = require("content/cells/shifters/Shifter")

local Bishifter = setmetatable({
    name = "bishifter",
    k3 = 256,
    title = "Bishifter",
    description = "Shifter that outputs to both sides at once.",
    outputs = { 1, 3 },
    rear = true
}, { __index = Shifter })
Bishifter.__index = Bishifter

return Bishifter
