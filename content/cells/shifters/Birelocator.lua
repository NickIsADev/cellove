local Shifter = require("content/cells/shifters/Shifter")

local Birelocator = setmetatable({
    name = "birelocator",
    k3 = 262,
    title = "Birelocator",
    description = "Bishifter that does not rotate the outputted cells.",
    outputs = { 1, 3 },
    rear = true,
    rotates = false
}, { __index = Shifter })
Birelocator.__index = Birelocator

return Birelocator
