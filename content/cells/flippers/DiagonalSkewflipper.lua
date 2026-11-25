local Skewflipper = require("content/cells/flippers/Skewflipper")

local DiagonalSkewflipper = setmetatable({
    name = "diagonalskewflipper",
    k3 = 1049,
    title = "Diagonal Skewflipper",
    description = "Flips the diagonal cells across a diagonal every tick.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = Skewflipper })
DiagonalSkewflipper.__index = DiagonalSkewflipper

return DiagonalSkewflipper
