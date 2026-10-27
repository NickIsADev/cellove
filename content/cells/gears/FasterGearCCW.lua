local BaseGear = require("content/cells/abstract/BaseGear")

local FasterGearCCW = setmetatable({
    name = "fastergear_ccw",
    k3 = 474,
    title = "Faster Gear (CCW)",
    description = "Rotates surrounding cells around itself 135 degrees counter-clockwise every tick. Gets jammed by immovable cells and other gears.",
    spin = -1,
    steps = 3
}, { __index = BaseGear })
FasterGearCCW.__index = FasterGearCCW

return FasterGearCCW
