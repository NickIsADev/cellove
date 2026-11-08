local Rowimpulsor = require("content/cells/impulsors/Rowimpulsor")

local Hemirowimpulsor = setmetatable({
    name = "hemirowimpulsor",
    k3 = 1015,
    title = "Hemirowimpulsor",
    description = "Rowimpulsor that only pulls in front of it and to its left.",
    inputs = { 0, 3 }
}, { __index = Rowimpulsor })
Hemirowimpulsor.__index = Hemirowimpulsor

return Hemirowimpulsor
