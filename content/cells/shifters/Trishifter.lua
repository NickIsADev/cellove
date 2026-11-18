local Shifter = require("content/cells/shifters/Shifter")

local Trishifter = setmetatable({
    name = "trishifter",
    k3 = 257,
    title = "Trishifter",
    description = "Shifter that outputs forward and to both sides at once.",
    outputs = { 0, 1, 3 },
    rear = true
}, { __index = Shifter })
Trishifter.__index = Trishifter

return Trishifter
