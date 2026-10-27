local BaseGear = require("content/cells/abstract/BaseGear")

local FastCogRNG = setmetatable({
    name = "fastcog_rng",
    k3 = 974,
    title = "Fast Cog (RNG)",
    description = "Rotates surrounding cells around itself 90 degrees clockwise or counter-clockwise at random every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    random = true,
    steps = 2,
    cog = true
}, { __index = BaseGear })
FastCogRNG.__index = FastCogRNG

return FastCogRNG
