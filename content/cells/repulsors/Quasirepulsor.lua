local Repulsor = require("content/cells/repulsors/Repulsor")

local Quasirepulsor = setmetatable({
    name = "quasirepulsor",
    k3 = 409,
    title = "Quasirepulsor",
    description = "Repulsor that only pushes in front of it.",
    outputs = { 0 }
}, { __index = Repulsor })
Quasirepulsor.__index = Quasirepulsor

return Quasirepulsor
