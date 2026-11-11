local BaseSuperRotator = require("content/cells/abstract/BaseSuperRotator")

local SuperRotatorCCW = setmetatable({
    name = "superrotator_ccw",
    k3 = 443,
    title = "Super Rotator (CCW)",
    description = "Rotates every cell connected to it counter-clockwise every tick.",
    spin = -1
}, { __index = BaseSuperRotator })
SuperRotatorCCW.__index = SuperRotatorCCW

return SuperRotatorCCW
