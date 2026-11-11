local BaseSuperRotator = require("content/cells/abstract/BaseSuperRotator")

local SuperRotatorCW = setmetatable({
    name = "superrotator_cw",
    k3 = 442,
    title = "Super Rotator (CW)",
    description = "Rotates every cell connected to it clockwise every tick."
}, { __index = BaseSuperRotator })
SuperRotatorCW.__index = SuperRotatorCW

return SuperRotatorCW
