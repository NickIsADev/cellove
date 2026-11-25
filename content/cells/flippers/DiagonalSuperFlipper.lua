local SuperFlipper = require("content/cells/flippers/SuperFlipper")

local DiagonalSuperFlipper = setmetatable({
    name = "diagonalsuperflipper",
    k3 = 714,
    title = "Diagonal Super Flipper",
    description = "Flips every cell connected to it across a diagonal every tick.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = SuperFlipper })
DiagonalSuperFlipper.__index = DiagonalSuperFlipper

return DiagonalSuperFlipper
