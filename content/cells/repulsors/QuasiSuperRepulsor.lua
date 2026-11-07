local SuperRepulsor = require("content/cells/repulsors/SuperRepulsor")

local QuasiSuperRepulsor = setmetatable({
    name = "quasisuperrepulsor",
    k3 = 722,
    title = "Super Quasirepulsor",
    description = "Super Repulsor that only pushes in front of it.",
    outputs = { 0 }
}, { __index = SuperRepulsor })
QuasiSuperRepulsor.__index = QuasiSuperRepulsor

return QuasiSuperRepulsor
