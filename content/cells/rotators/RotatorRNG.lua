local BaseRotator = require("content/cells/abstract/BaseRotator")

local RotatorRNG = setmetatable({
    name = "rotator_rng",
    k3 = 960,
    title = "Rotator (RNG)",
    description = "Rotates adjacent cells in a random direction every tick.",
    random = true
}, { __index = BaseRotator })
RotatorRNG.__index = RotatorRNG

return RotatorRNG
