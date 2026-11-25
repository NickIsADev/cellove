local SemiflipperHorizontal = require("content/cells/flippers/SemiflipperHorizontal")

local DiagonalSemiflipperHorizontal = setmetatable({
    name = "diagonalsemiflipper_horizontal",
    k3 = 655,
    title = "Diagonal Semiflipper (Horizontal)",
    description = "Flips the cells to its left and right across a diagonal every tick. Flips above and below when rotated.",
    faces = { 1.5, 3.5 },
    axis = "antidiagonal",
    twin = "diagonalsemiflipper_vertical"
}, { __index = SemiflipperHorizontal })
DiagonalSemiflipperHorizontal.__index = DiagonalSemiflipperHorizontal

return DiagonalSemiflipperHorizontal
