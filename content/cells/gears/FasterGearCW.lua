local BaseGear = require("content/cells/abstract/BaseGear")

local FasterGearCW = setmetatable({
    name = "fastergear_cw",
    k3 = 473,
    title = "Faster Gear (CW)",
    description = "Rotates surrounding cells around itself 135 degrees clockwise every tick. Gets jammed by immovable cells and other gears.",
    steps = 3
}, { __index = BaseGear })
FasterGearCW.__index = FasterGearCW

return FasterGearCW
