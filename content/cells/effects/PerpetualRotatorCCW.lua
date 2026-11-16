local BasePerpetual = require("content/cells/abstract/BasePerpetual")

local PerpetualRotatorCCW = setmetatable({
    name = "perpetualrotator_ccw",
    k3 = 523,
    title = "Perpetual Rotator (CCW)",
    description = "Makes adjacent cells rotate counter-clockwise every tick, even after moving away.",
    value = "ccw"
}, { __index = BasePerpetual })
PerpetualRotatorCCW.__index = PerpetualRotatorCCW

return PerpetualRotatorCCW
