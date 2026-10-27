local BaseGear = require("content/cells/abstract/BaseGear")

local FastGearRNG = setmetatable({
    name = "fastgear_rng",
    k3 = 969,
    title = "Fast Gear (RNG)",
    description = "Rotates surrounding cells around itself 90 degrees clockwise or counter-clockwise at random every tick. Gets jammed by immovable cells and other gears.",
    random = true,
    steps = 2
}, { __index = BaseGear })
FastGearRNG.__index = FastGearRNG

return FastGearRNG
