local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local DivergerRNG = setmetatable({
    name = "diverger_rng",
    k3 = 980,
    title = "Diverger (RNG)",
    description = "Sends cells out in a random direction.",
    routes = {
        [0] = { -1, 0, 1 },
        [1] = { -1, 0, 1 },
        [2] = { -1, 0, 1 },
        [3] = { -1, 0, 1 }
    }
}, { __index = BaseDiverger })
DivergerRNG.__index = DivergerRNG

return DivergerRNG
