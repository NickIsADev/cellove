local Rowimpulsor = require("content/cells/impulsors/Rowimpulsor")

local Quasirowimpulsor = setmetatable({
    name = "quasirowimpulsor",
    k3 = 1014,
    title = "Quasirowimpulsor",
    description = "Rowimpulsor that only pulls in front of it.",
    inputs = { 0 }
}, { __index = Rowimpulsor })
Quasirowimpulsor.__index = Quasirowimpulsor

return Quasirowimpulsor
