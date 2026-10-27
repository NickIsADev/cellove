local BaseGear = require("content/cells/abstract/BaseGear")

local GearRNG = setmetatable({
    name = "gear_rng",
    k3 = 968,
    title = "Gear (RNG)",
    description = "Rotates surrounding cells around itself clockwise or counter-clockwise at random every tick. Gets jammed by immovable cells and other gears.",
    random = true
}, { __index = BaseGear })
GearRNG.__index = GearRNG

return GearRNG
