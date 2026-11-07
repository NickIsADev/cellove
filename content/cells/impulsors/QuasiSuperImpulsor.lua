local SuperImpulsor = require("content/cells/impulsors/SuperImpulsor")

local QuasiSuperImpulsor = setmetatable({
    name = "quasisuperimpulsor",
    k3 = 730,
    title = "Super Quasiimpulsor",
    description = "Super Impulsor that only pulls in front of it.",
    inputs = { 0 }
}, { __index = SuperImpulsor })
QuasiSuperImpulsor.__index = QuasiSuperImpulsor

return QuasiSuperImpulsor
