local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipMinicog = setmetatable({
    name = "diagonalflipminicog",
    k3 = 1030,
    title = "Diagonal Flip Minicog",
    description = "Flips adjacent cells along a diagonal every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    axis = "diagonal",
    cog = true
}, { __index = BaseFlipGear })
DiagonalFlipMinicog.__index = DiagonalFlipMinicog

return DiagonalFlipMinicog
