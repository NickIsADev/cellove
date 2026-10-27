local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipGear = setmetatable({
    name = "diagonalflipgear",
    k3 = 1022,
    title = "Diagonal Flip Gear",
    description = "Flips surrounding cells along a diagonal every tick. Gets jammed by immovable cells and other gears.",
    axis = "diagonal"
}, { __index = BaseFlipGear })
DiagonalFlipGear.__index = DiagonalFlipGear

return DiagonalFlipGear
