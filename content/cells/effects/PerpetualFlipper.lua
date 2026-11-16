local BasePerpetualFlipper = require("content/cells/abstract/BasePerpetualFlipper")

local PerpetualFlipper = setmetatable({
    name = "perpetualflipper",
    k3 = 535,
    title = "Perpetual Flipper",
    description = "Makes adjacent cells flip every tick, even after moving away."
}, { __index = BasePerpetualFlipper })
PerpetualFlipper.__index = PerpetualFlipper

return PerpetualFlipper
