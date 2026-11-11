local BaseRotator = require("content/cells/abstract/BaseRotator")

local MegarotatorRNG = setmetatable({
    name = "megarotator_rng",
    k3 = 962,
    title = "Megarotator (RNG)",
    description = "Rotates surrounding cells in a random direction every tick.",
    sides = { orthogonal = true, diagonal = true },
    random = true
}, { __index = BaseRotator })
MegarotatorRNG.__index = MegarotatorRNG

return MegarotatorRNG
