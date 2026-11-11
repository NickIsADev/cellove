local BaseRotator = require("content/cells/abstract/BaseRotator")

local SemirotatorCCW = setmetatable({
    name = "semirotator_ccw",
    k3 = 67,
    title = "Semirotator (CCW)",
    description = "Rotates the cells in front of and behind it counter-clockwise every tick.",
    faces = { 0, 2 },
    outputs = { 0, 2 },
    spin = -1
}, { __index = BaseRotator })
SemirotatorCCW.__index = SemirotatorCCW

return SemirotatorCCW
