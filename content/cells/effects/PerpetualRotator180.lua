local BasePerpetual = require("content/cells/abstract/BasePerpetual")

local PerpetualRotator180 = setmetatable({
    name = "perpetualrotator_180",
    k3 = 524,
    title = "Perpetual Rotator (180)",
    description = "Makes adjacent cells rotate 180 degrees every tick, even after moving away.",
    categories = { "rotators", "effects" },
    value = "half"
}, { __index = BasePerpetual })
PerpetualRotator180.__index = PerpetualRotator180

return PerpetualRotator180
