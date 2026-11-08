local Impulsor = require("content/cells/impulsors/Impulsor")

local Quasiimpulsor = setmetatable({
    name = "quasiimpulsor",
    k3 = 414,
    title = "Quasiimpulsor",
    description = "Impulsor that only pulls in front of it.",
    inputs = { 0 }
}, { __index = Impulsor })
Quasiimpulsor.__index = Quasiimpulsor

return Quasiimpulsor
