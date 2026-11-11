local BaseRotator = require("content/cells/abstract/BaseRotator")

local HenarotatorCW = setmetatable({
    name = "henarotator_cw",
    k3 = 1003,
    title = "Henarotator (CW)",
    description = "Rotates the cells in front of, to the left of and to the right of it clockwise every tick.",
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 }
}, { __index = BaseRotator })
HenarotatorCW.__index = HenarotatorCW

return HenarotatorCW
