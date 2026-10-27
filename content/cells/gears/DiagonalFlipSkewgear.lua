local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipSkewgear = setmetatable({
    name = "diagonalflipskewgear",
    k3 = 1026,
    title = "Diagonal Flip Skewgear",
    description = "Flips diagonal cells along a diagonal every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    axis = "diagonal"
}, { __index = BaseFlipGear })
DiagonalFlipSkewgear.__index = DiagonalFlipSkewgear

return DiagonalFlipSkewgear
