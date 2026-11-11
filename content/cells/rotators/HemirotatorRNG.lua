local BaseRotator = require("content/cells/abstract/BaseRotator")

local HemirotatorRNG = setmetatable({
    name = "hemirotator_rng",
    k3 = 1002,
    title = "Hemirotator (RNG)",
    description = "Rotates the cells in front of and to the left of it in a random direction every tick.",
    faces = { 0, 3 },
    outputs = { 0, 3 },
    random = true
}, { __index = BaseRotator })
HemirotatorRNG.__index = HemirotatorRNG

return HemirotatorRNG
