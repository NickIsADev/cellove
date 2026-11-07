local Rowimpulsor = require("content/cells/impulsors/Rowimpulsor")

local Semirowimpulsor = setmetatable({
    name = "semirowimpulsor",
    k3 = 1013,
    title = "Semirowimpulsor",
    description = "Rowimpulsor that only pulls in front of and behind it.",
    inputs = { 0, 2 }
}, { __index = Rowimpulsor })
Semirowimpulsor.__index = Semirowimpulsor

return Semirowimpulsor
