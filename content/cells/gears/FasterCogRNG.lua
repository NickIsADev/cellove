local BaseGear = require("content/cells/abstract/BaseGear")

local FasterCogRNG = setmetatable({
    name = "fastercog_rng",
    k3 = 975,
    title = "Faster Cog (RNG)",
    description = "Rotates surrounding cells around itself 135 degrees clockwise or counter-clockwise at random every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    random = true,
    steps = 3,
    cog = true
}, { __index = BaseGear })
FasterCogRNG.__index = FasterCogRNG

return FasterCogRNG
