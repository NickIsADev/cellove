local BaseRotator = require("content/cells/abstract/BaseRotator")

local RotatorCW = setmetatable({
    name = "rotator_cw",
    k3 = 9,
    title = "Rotator (CW)",
    description = "Rotates adjacent cells clockwise every tick."
}, { __index = BaseRotator })
RotatorCW.__index = RotatorCW

return RotatorCW
