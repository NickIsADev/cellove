local PipeRNG = require("content/cells/pipes/PipeRNG")

local TubeRNG = setmetatable({
    name = "tube_rng",
    title = "Tube (RNG)",
    description = "Pipe (RNG) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = PipeRNG })
TubeRNG.__index = TubeRNG

return TubeRNG
