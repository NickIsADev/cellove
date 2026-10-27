local BaseRotator = require("content/cells/abstract/BaseRotator")

local Rotator180 = setmetatable({
    name = "rotator_180",
    k3 = 11,
    title = "Rotator (180)",
    description = "Rotates adjacent cells 180 degrees every tick.",
    spin = 2
}, { __index = BaseRotator })
Rotator180.__index = Rotator180

return Rotator180
