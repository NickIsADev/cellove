local EdgeDivergerRNG = require("content/cells/divergers/EdgeDivergerRNG")

local EdgeDisplacerRNG = setmetatable({
    name = "edgedisplacer_rng",
    k3 = 983,
    title = "Edge Displacer (RNG)",
    description = "Edge Diverger (RNG) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = EdgeDivergerRNG })
EdgeDisplacerRNG.__index = EdgeDisplacerRNG

return EdgeDisplacerRNG
