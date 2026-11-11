local BaseRotator = require("content/cells/abstract/BaseRotator")

local HenarotatorCCW = setmetatable({
    name = "henarotator_ccw",
    k3 = 1004,
    title = "Henarotator (CCW)",
    description = "Rotates the cells in front of, to the left of and to the right of it counter-clockwise every tick.",
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 },
    spin = -1
}, { __index = BaseRotator })
HenarotatorCCW.__index = HenarotatorCCW

return HenarotatorCCW
