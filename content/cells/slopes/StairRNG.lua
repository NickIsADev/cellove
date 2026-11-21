local Stair = require("content/cells/slopes/Stair")

local StairRNG = setmetatable({
    name = "stair_rng",
    k3 = 979,
    title = "Stair (RNG)",
    description = "Stair that shifts cells in a random direction.",
    sense = "rng",
    faces = {}
}, { __index = Stair })
StairRNG.__index = StairRNG

return StairRNG
