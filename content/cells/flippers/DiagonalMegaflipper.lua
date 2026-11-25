local Megaflipper = require("content/cells/flippers/Megaflipper")

local DiagonalMegaflipper = setmetatable({
    name = "diagonalmegaflipper",
    k3 = 713,
    title = "Diagonal Megaflipper",
    description = "Flips all surrounding cells across a diagonal every tick.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = Megaflipper })
DiagonalMegaflipper.__index = DiagonalMegaflipper

return DiagonalMegaflipper
