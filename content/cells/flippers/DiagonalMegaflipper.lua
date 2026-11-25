local Megaflipper = require("content/cells/flippers/Megaflipper")

local DiagonalMegaflipper = setmetatable({
    name = "diagonalmegaflipper",
    k3 = 713,
    title = "Diagonal Megaflipper",
    description = "Flips surrounding cells along a diagonal every tick.",
    slanted = true,
    axis = "diagonal"
}, { __index = Megaflipper })
DiagonalMegaflipper.__index = DiagonalMegaflipper

return DiagonalMegaflipper
