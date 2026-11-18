local Shifter = require("content/cells/shifters/Shifter")

local Trirelocator = setmetatable({
    name = "trirelocator",
    k3 = 263,
    title = "Trirelocator",
    description = "Trishifter that does not rotate the outputted cells.",
    outputs = { 0, 1, 3 },
    rear = true,
    rotates = false
}, { __index = Shifter })
Trirelocator.__index = Trirelocator

return Trirelocator
