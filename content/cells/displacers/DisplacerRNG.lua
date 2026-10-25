local DivergerRNG = require("content/cells/divergers/DivergerRNG")

local DisplacerRNG = setmetatable({
    name = "displacer_rng",
    k3 = 981,
    title = "Displacer (RNG)",
    description = "Diverger (RNG) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = DivergerRNG })
DisplacerRNG.__index = DisplacerRNG

return DisplacerRNG
