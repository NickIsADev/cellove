local BaseRotator = require("content/cells/abstract/BaseRotator")

local SemirotatorCW = setmetatable({
    name = "semirotator_cw",
    k3 = 66,
    title = "Semirotator (CW)",
    description = "Rotates the cells in front of and behind it clockwise every tick.",
    faces = { 0, 2 },
    outputs = { 0, 2 }
}, { __index = BaseRotator })
SemirotatorCW.__index = SemirotatorCW

return SemirotatorCW
