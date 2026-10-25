local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local EdgeDivergerRNG = setmetatable({
    name = "edgediverger_rng",
    k3 = 982,
    title = "Edge Diverger (RNG)",
    description = "Diverger (RNG), but cells entering its front pass straight through.",
    routes = {
        [0] = 0,
        [1] = { -1, 0 },
        [2] = { -1, 1 },
        [3] = { 0, 1 }
    }
}, { __index = BaseDiverger })
EdgeDivergerRNG.__index = EdgeDivergerRNG

return EdgeDivergerRNG
