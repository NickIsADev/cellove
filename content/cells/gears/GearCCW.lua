local BaseGear = require("content/cells/abstract/BaseGear")

local GearCCW = setmetatable({
    name = "gear_ccw",
    k3 = 19,
    title = "Gear (CCW)",
    description = "Rotates surrounding cells around itself counter-clockwise every tick. Gets jammed by immovable cells and other gears.",
    spin = -1
}, { __index = BaseGear })
GearCCW.__index = GearCCW

return GearCCW
