local BaseRotator = require("content/cells/abstract/BaseRotator")

local HemirotatorCW = setmetatable({
    name = "hemirotator_cw",
    k3 = 998,
    title = "Hemirotator (CW)",
    description = "Rotates the cells in front of and to the left of it clockwise every tick.",
    faces = { 0, 3 },
    outputs = { 0, 3 }
}, { __index = BaseRotator })
HemirotatorCW.__index = HemirotatorCW

return HemirotatorCW
