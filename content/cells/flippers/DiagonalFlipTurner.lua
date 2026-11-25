local FlipTurner = require("content/cells/flippers/FlipTurner")

local DiagonalFlipTurner = setmetatable({
    name = "diagonalflipturner",
    k3 = 712,
    title = "Diagonal Flip Turner",
    description = "Flips any cell that pushes it along a diagonal.",
    slanted = true,
    axis = "diagonal"
}, { __index = FlipTurner })
DiagonalFlipTurner.__index = DiagonalFlipTurner

return DiagonalFlipTurner
