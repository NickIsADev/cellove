local BaseRotator = require("content/cells/abstract/BaseRotator")

local SkewrotatorCW = setmetatable({
    name = "skewrotator_cw",
    k3 = 957,
    title = "Skewrotator (CW)",
    description = "Rotates diagonal cells clockwise every tick.",
    sides = { diagonal = true }
}, { __index = BaseRotator })
SkewrotatorCW.__index = SkewrotatorCW

return SkewrotatorCW
