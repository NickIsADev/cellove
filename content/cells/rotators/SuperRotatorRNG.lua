local BaseSuperRotator = require("content/cells/abstract/BaseSuperRotator")

local SuperRotatorRNG = setmetatable({
    name = "superrotator_rng",
    k3 = 964,
    title = "Super Rotator (RNG)",
    description = "Rotates every cell connected to it in a random direction every tick.",
    random = true
}, { __index = BaseSuperRotator })
SuperRotatorRNG.__index = SuperRotatorRNG

return SuperRotatorRNG
