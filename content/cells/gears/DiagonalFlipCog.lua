local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local DiagonalFlipCog = setmetatable({
    name = "diagonalflipcog",
    k3 = 1028,
    title = "Diagonal Flip Cog",
    description = "Flips surrounding cells along a diagonal every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    axis = "diagonal",
    cog = true
}, { __index = BaseFlipGear })
DiagonalFlipCog.__index = DiagonalFlipCog

return DiagonalFlipCog
