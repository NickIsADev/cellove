local BaseGear = require("content/cells/abstract/BaseGear")

local SkewgearCCW = setmetatable({
    name = "skewgear_ccw",
    k3 = 483,
    title = "Skewgear (CCW)",
    description = "Rotates diagonal cells around itself counter-clockwise every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    spin = -1
}, { __index = BaseGear })
SkewgearCCW.__index = SkewgearCCW

return SkewgearCCW
