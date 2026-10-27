local BaseGear = require("content/cells/abstract/BaseGear")

local FasterGearRNG = setmetatable({
    name = "fastergear_rng",
    k3 = 970,
    title = "Faster Gear (RNG)",
    description = "Rotates surrounding cells around itself 135 degrees clockwise or counter-clockwise at random every tick. Gets jammed by immovable cells and other gears.",
    random = true,
    steps = 3
}, { __index = BaseGear })
FasterGearRNG.__index = FasterGearRNG

return FasterGearRNG
