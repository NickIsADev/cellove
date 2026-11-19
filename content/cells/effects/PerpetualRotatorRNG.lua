local BasePerpetual = require("content/cells/abstract/BasePerpetual")

local PerpetualRotatorRNG = setmetatable({
    name = "perpetualrotator_rng",
    k3 = 967,
    title = "Perpetual Rotator (RNG)",
    description = "Makes adjacent cells rotate in a random direction every tick, even after moving away.",
    categories = { "rotators", "effects" },
    value = "random"
}, { __index = BasePerpetual })
PerpetualRotatorRNG.__index = PerpetualRotatorRNG

return PerpetualRotatorRNG
