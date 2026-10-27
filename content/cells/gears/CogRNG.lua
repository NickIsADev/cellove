local BaseGear = require("content/cells/abstract/BaseGear")

local CogRNG = setmetatable({
    name = "cog_rng",
    k3 = 973,
    title = "Cog (RNG)",
    description = "Rotates surrounding cells around itself clockwise or counter-clockwise at random every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    random = true,
    cog = true
}, { __index = BaseGear })
CogRNG.__index = CogRNG

return CogRNG
