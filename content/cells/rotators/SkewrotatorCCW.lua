local BaseRotator = require("content/cells/abstract/BaseRotator")

local SkewrotatorCCW = setmetatable({
    name = "skewrotator_ccw",
    k3 = 958,
    title = "Skewrotator (CCW)",
    description = "Rotates diagonal cells counter-clockwise every tick.",
    sides = { diagonal = true },
    spin = -1
}, { __index = BaseRotator })
SkewrotatorCCW.__index = SkewrotatorCCW

return SkewrotatorCCW
