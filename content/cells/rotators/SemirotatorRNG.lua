local BaseRotator = require("content/cells/abstract/BaseRotator")

local SemirotatorRNG = setmetatable({
    name = "semirotator_rng",
    k3 = 961,
    title = "Semirotator (RNG)",
    description = "Rotates the cells in front of and behind it in a random direction every tick.",
    faces = { 0, 2 },
    outputs = { 0, 2 },
    random = true
}, { __index = BaseRotator })
SemirotatorRNG.__index = SemirotatorRNG

return SemirotatorRNG
