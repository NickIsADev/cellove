local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipMinigear = setmetatable({
    name = "diagonalflipminigear",
    k3 = 1024,
    title = "Diagonal Flip Minigear",
    description = "Flips adjacent cells along a diagonal every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    axis = "diagonal"
}, { __index = BaseFlipGear })
DiagonalFlipMinigear.__index = DiagonalFlipMinigear

return DiagonalFlipMinigear
