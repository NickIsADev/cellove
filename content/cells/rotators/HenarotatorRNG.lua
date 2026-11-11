local BaseRotator = require("content/cells/abstract/BaseRotator")

local HenarotatorRNG = setmetatable({
    name = "henarotator_rng",
    k3 = 1006,
    title = "Henarotator (RNG)",
    description = "Rotates the cells in front of, to the left of and to the right of it in a random direction every tick.",
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 },
    random = true
}, { __index = BaseRotator })
HenarotatorRNG.__index = HenarotatorRNG

return HenarotatorRNG
