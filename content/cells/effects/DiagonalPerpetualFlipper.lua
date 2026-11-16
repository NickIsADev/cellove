local BasePerpetualFlipper = require("content/cells/abstract/BasePerpetualFlipper")

local DiagonalPerpetualFlipper = setmetatable({
    name = "diagonalperpetualflipper",
    k3 = 715,
    title = "Diagonal Perpetual Flipper",
    description = "Makes adjacent cells flip diagonally every tick, even after moving away.",
    axis = "diagonal"
}, { __index = BasePerpetualFlipper })
DiagonalPerpetualFlipper.__index = DiagonalPerpetualFlipper

return DiagonalPerpetualFlipper
