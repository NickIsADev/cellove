local Slope = require("content/cells/slopes/Slope")

local SlopeRNG = setmetatable({
    name = "slope_rng",
    k3 = 978,
    title = "Slope (RNG)",
    description = "Slope that shifts cells in a random direction.",
    sense = "rng",
    faces = {}
}, { __index = Slope })
SlopeRNG.__index = SlopeRNG

return SlopeRNG
