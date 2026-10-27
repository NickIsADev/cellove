local BaseGear = require("content/cells/abstract/BaseGear")

local SkewcogCCW = setmetatable({
    name = "skewcog_ccw",
    k3 = 486,
    title = "Skewcog (CCW)",
    description = "Rotates diagonal cells around itself counter-clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    spin = -1,
    cog = true
}, { __index = BaseGear })
SkewcogCCW.__index = SkewcogCCW

return SkewcogCCW
