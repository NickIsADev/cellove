local SemiflipperVertical = require("content/cells/flippers/SemiflipperVertical")

local DiagonalSemiflipperVertical = setmetatable({
    name = "diagonalsemiflipper_vertical",
    k3 = 656,
    title = "Diagonal Semiflipper (Vertical)",
    description = "Flips the cells above and below it across a diagonal every tick. Flips left and right when rotated.",
    faces = { 1.5, 3.5 },
    axis = "antidiagonal",
    twin = "diagonalsemiflipper_horizontal"
}, { __index = SemiflipperVertical })
DiagonalSemiflipperVertical.__index = DiagonalSemiflipperVertical

return DiagonalSemiflipperVertical
