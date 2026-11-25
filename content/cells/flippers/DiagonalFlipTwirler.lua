local FlipTwirler = require("content/cells/flippers/FlipTwirler")

local DiagonalFlipTwirler = setmetatable({
    name = "diagonalfliptwirler",
    k3 = 1131,
    title = "Diagonal Flip Twirler",
    description = "When pushed, flips the cell it pushes into along a diagonal.",
    slanted = true,
    axis = "diagonal"
}, { __index = FlipTwirler })
DiagonalFlipTwirler.__index = DiagonalFlipTwirler

return DiagonalFlipTwirler
