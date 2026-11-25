local Flipper = require("content/cells/flippers/Flipper")

local DiagonalFlipper = setmetatable({
    name = "diagonalflipper",
    k3 = 654,
    title = "Diagonal Flipper",
    description = "Flips adjacent cells across a diagonal every tick.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = Flipper })
DiagonalFlipper.__index = DiagonalFlipper

return DiagonalFlipper
