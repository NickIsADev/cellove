local Slant = require("content/cells/slopes/Slant")

local SlantRNG = setmetatable({
    name = "slant_rng",
    k3 = 1020,
    title = "Slant (RNG)",
    description = "Slant that shifts cells in a random direction.",
    sense = "rng",
    faces = {}
}, { __index = Slant })
SlantRNG.__index = SlantRNG

return SlantRNG
