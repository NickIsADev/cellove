local Flipper = require("content/cells/flippers/Flipper")

local DiagonalFlipper = setmetatable({
    name = "diagonalflipper",
    k3 = 654,
    title = "Diagonal Flipper",
    description = "Flips adjacent cells along a diagonal every tick.",
    slanted = true,
    axis = "diagonal"
}, { __index = Flipper })
DiagonalFlipper.__index = DiagonalFlipper

return DiagonalFlipper
