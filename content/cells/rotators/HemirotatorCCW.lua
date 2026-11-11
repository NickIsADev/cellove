local BaseRotator = require("content/cells/abstract/BaseRotator")

local HemirotatorCCW = setmetatable({
    name = "hemirotator_ccw",
    k3 = 999,
    title = "Hemirotator (CCW)",
    description = "Rotates the cells in front of and to the left of it counter-clockwise every tick.",
    faces = { 0, 3 },
    outputs = { 0, 3 },
    spin = -1
}, { __index = BaseRotator })
HemirotatorCCW.__index = HemirotatorCCW

return HemirotatorCCW
