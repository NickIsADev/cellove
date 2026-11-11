local BaseRotator = require("content/cells/abstract/BaseRotator")

local QuasirotatorRNG = setmetatable({
    name = "quasirotator_rng",
    k3 = 997,
    title = "Quasirotator (RNG)",
    description = "Rotates the cell in front of it in a random direction every tick.",
    faces = { 0 },
    outputs = { 0 },
    random = true
}, { __index = BaseRotator })
QuasirotatorRNG.__index = QuasirotatorRNG

return QuasirotatorRNG
