local BaseRotator = require("content/cells/abstract/BaseRotator")

local SkewrotatorRNG = setmetatable({
    name = "skewrotator_rng",
    k3 = 963,
    title = "Skewrotator (RNG)",
    description = "Rotates diagonal cells in a random direction every tick.",
    sides = { diagonal = true },
    random = true
}, { __index = BaseRotator })
SkewrotatorRNG.__index = SkewrotatorRNG

return SkewrotatorRNG
