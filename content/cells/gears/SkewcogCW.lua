local BaseGear = require("content/cells/abstract/BaseGear")

local SkewcogCW = setmetatable({
    name = "skewcog_cw",
    k3 = 485,
    title = "Skewcog (CW)",
    description = "Rotates diagonal cells around itself clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    cog = true
}, { __index = BaseGear })
SkewcogCW.__index = SkewcogCW

return SkewcogCW
