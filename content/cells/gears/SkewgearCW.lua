local BaseGear = require("content/cells/abstract/BaseGear")

local SkewgearCW = setmetatable({
    name = "skewgear_cw",
    k3 = 482,
    title = "Skewgear (CW)",
    description = "Rotates diagonal cells around itself clockwise every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true }
}, { __index = BaseGear })
SkewgearCW.__index = SkewgearCW

return SkewgearCW
