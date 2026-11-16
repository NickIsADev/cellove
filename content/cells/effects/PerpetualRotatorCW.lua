local BasePerpetual = require("content/cells/abstract/BasePerpetual")

local PerpetualRotatorCW = setmetatable({
    name = "perpetualrotator_cw",
    k3 = 522,
    title = "Perpetual Rotator (CW)",
    description = "Makes adjacent cells rotate clockwise every tick, even after moving away.",
    value = "cw"
}, { __index = BasePerpetual })
PerpetualRotatorCW.__index = PerpetualRotatorCW

return PerpetualRotatorCW
