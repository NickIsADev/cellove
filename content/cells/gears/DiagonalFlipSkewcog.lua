local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipSkewcog = setmetatable({
    name = "diagonalflipskewcog",
    k3 = 1032,
    title = "Diagonal Flip Skewcog",
    description = "Flips diagonal cells along a diagonal every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    axis = "diagonal",
    cog = true
}, { __index = BaseFlipGear })
DiagonalFlipSkewcog.__index = DiagonalFlipSkewcog

return DiagonalFlipSkewcog
