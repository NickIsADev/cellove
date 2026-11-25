local FlipTwirler = require("content/cells/rotators/FlipTwirler")

local DiagonalFlipTwirler = setmetatable({
    name = "diagonalfliptwirler",
    k3 = 1131,
    title = "Diagonal Flip Twirler",
    description = "When pushed, flips the cell it pushes into across a diagonal.",
    faces = { 1.5, 3.5 },
    axis = "diagonal"
}, { __index = FlipTwirler })
DiagonalFlipTwirler.__index = DiagonalFlipTwirler

return DiagonalFlipTwirler
