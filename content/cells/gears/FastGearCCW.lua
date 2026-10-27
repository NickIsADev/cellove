local BaseGear = require("content/cells/abstract/BaseGear")

local FastGearCCW = setmetatable({
    name = "fastgear_ccw",
    k3 = 470,
    title = "Fast Gear (CCW)",
    description = "Rotates surrounding cells around itself 90 degrees counter-clockwise every tick. Gets jammed by immovable cells and other gears.",
    spin = -1,
    steps = 2
}, { __index = BaseGear })
FastGearCCW.__index = FastGearCCW

return FastGearCCW
