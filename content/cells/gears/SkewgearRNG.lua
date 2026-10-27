local BaseGear = require("content/cells/abstract/BaseGear")

local SkewgearRNG = setmetatable({
    name = "skewgear_rng",
    k3 = 972,
    title = "Skewgear (RNG)",
    description = "Rotates diagonal cells around itself clockwise or counter-clockwise at random every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    random = true
}, { __index = BaseGear })
SkewgearRNG.__index = SkewgearRNG

return SkewgearRNG
