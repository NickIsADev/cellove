local BaseRotator = require("content/cells/abstract/BaseRotator")

local Hemirotator180 = setmetatable({
    name = "hemirotator_180",
    k3 = 1001,
    title = "Hemirotator (180)",
    description = "Rotates the cells in front of and to the left of it 180 degrees every tick.",
    faces = { 0, 3 },
    outputs = { 0, 3 },
    spin = 2
}, { __index = BaseRotator })
Hemirotator180.__index = Hemirotator180

return Hemirotator180
