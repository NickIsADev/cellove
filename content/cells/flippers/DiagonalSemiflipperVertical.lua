local SemiflipperVertical = require("content/cells/flippers/SemiflipperVertical")

local DiagonalSemiflipperVertical = setmetatable({
    name = "diagonalsemiflipper_vertical",
    k3 = 656,
    title = "Diagonal Semiflipper (Vertical)",
    description = "Flips the cells to its left and right along a diagonal every tick.",
    slanted = true,
    axis = "antidiagonal"
}, { __index = SemiflipperVertical })
DiagonalSemiflipperVertical.__index = DiagonalSemiflipperVertical

return DiagonalSemiflipperVertical
