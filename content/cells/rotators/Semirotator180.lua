local BaseRotator = require("content/cells/abstract/BaseRotator")

local Semirotator180 = setmetatable({
    name = "semirotator_180",
    k3 = 68,
    title = "Semirotator (180)",
    description = "Rotates the cells in front of and behind it 180 degrees every tick.",
    faces = { 0, 2 },
    outputs = { 0, 2 },
    spin = 2
}, { __index = BaseRotator })
Semirotator180.__index = Semirotator180

return Semirotator180
