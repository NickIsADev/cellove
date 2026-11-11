local BaseRotator = require("content/cells/abstract/BaseRotator")

local Skewrotator180 = setmetatable({
    name = "skewrotator_180",
    k3 = 959,
    title = "Skewrotator (180)",
    description = "Rotates diagonal cells 180 degrees every tick.",
    sides = { diagonal = true },
    spin = 2
}, { __index = BaseRotator })
Skewrotator180.__index = Skewrotator180

return Skewrotator180
