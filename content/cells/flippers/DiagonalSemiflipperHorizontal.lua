local SemiflipperHorizontal = require("content/cells/flippers/SemiflipperHorizontal")

local DiagonalSemiflipperHorizontal = setmetatable({
    name = "diagonalsemiflipper_horizontal",
    k3 = 655,
    title = "Diagonal Semiflipper (Horizontal)",
    description = "Flips the cells in front of and behind it along a diagonal every tick.",
    slanted = true,
    axis = "antidiagonal"
}, { __index = SemiflipperHorizontal })
DiagonalSemiflipperHorizontal.__index = DiagonalSemiflipperHorizontal

return DiagonalSemiflipperHorizontal
