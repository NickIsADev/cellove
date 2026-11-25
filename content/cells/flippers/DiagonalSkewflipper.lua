local Skewflipper = require("content/cells/flippers/Skewflipper")

local DiagonalSkewflipper = setmetatable({
    name = "diagonalskewflipper",
    k3 = 1049,
    title = "Diagonal Skewflipper",
    description = "Flips diagonal cells along a diagonal every tick.",
    slanted = true,
    axis = "diagonal"
}, { __index = Skewflipper })
DiagonalSkewflipper.__index = DiagonalSkewflipper

return DiagonalSkewflipper
