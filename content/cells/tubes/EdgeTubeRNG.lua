local EdgePipeRNG = require("content/cells/pipes/EdgePipeRNG")

local EdgeTubeRNG = setmetatable({
    name = "edgetube_rng",
    title = "Edge Tube (RNG)",
    description = "Edge Pipe (RNG) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = EdgePipeRNG })
EdgeTubeRNG.__index = EdgeTubeRNG

return EdgeTubeRNG
