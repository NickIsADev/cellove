local FlipTurner = require("content/cells/rotators/FlipTurner")

local DiagonalFlipTurner = setmetatable({
    name = "diagonalflipturner",
    k3 = 712,
    title = "Diagonal Flip Turner",
    description = "Flips any cell that pushes it across a diagonal.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = FlipTurner })
DiagonalFlipTurner.__index = DiagonalFlipTurner

return DiagonalFlipTurner
