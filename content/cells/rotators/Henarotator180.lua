local BaseRotator = require("content/cells/abstract/BaseRotator")

local Henarotator180 = setmetatable({
    name = "henarotator_180",
    k3 = 1005,
    title = "Henarotator (180)",
    description = "Rotates the cells in front of, to the left of and to the right of it 180 degrees every tick.",
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 },
    spin = 2
}, { __index = BaseRotator })
Henarotator180.__index = Henarotator180

return Henarotator180
