local BaseSuperRotator = require("content/cells/abstract/BaseSuperRotator")

local SuperRotator180 = setmetatable({
    name = "superrotator_180",
    k3 = 444,
    title = "Super Rotator (180)",
    description = "Rotates every cell connected to it 180 degrees every tick.",
    spin = 2
}, { __index = BaseSuperRotator })
SuperRotator180.__index = SuperRotator180

return SuperRotator180
