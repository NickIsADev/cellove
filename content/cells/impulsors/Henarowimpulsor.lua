local Rowimpulsor = require("content/cells/impulsors/Rowimpulsor")

local Henarowimpulsor = setmetatable({
    name = "henarowimpulsor",
    k3 = 1016,
    title = "Henarowimpulsor",
    description = "Rowimpulsor that only pulls in front of it and to both its sides.",
    inputs = { 0, 1, 3 }
}, { __index = Rowimpulsor })
Henarowimpulsor.__index = Henarowimpulsor

return Henarowimpulsor
