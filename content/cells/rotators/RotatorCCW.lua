local BaseRotator = require("content/cells/abstract/BaseRotator")

local RotatorCCW = setmetatable({
    name = "rotator_ccw",
    k3 = 10,
    title = "Rotator (CCW)",
    description = "Rotates adjacent cells counter-clockwise every tick.",
    spin = -1
}, { __index = BaseRotator })
RotatorCCW.__index = RotatorCCW

return RotatorCCW
