local BaseGear = require("content/cells/abstract/BaseGear")

local SkewcogRNG = setmetatable({
    name = "skewcog_rng",
    k3 = 977,
    title = "Skewcog (RNG)",
    description = "Rotates diagonal cells around itself clockwise or counter-clockwise at random every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    random = true,
    cog = true
}, { __index = BaseGear })
SkewcogRNG.__index = SkewcogRNG

return SkewcogRNG
