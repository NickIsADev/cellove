local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipMinicog = setmetatable({
    name = "flipminicog",
    k3 = 1029,
    title = "Flip Minicog",
    description = "Flips adjacent cells along the direction it faces every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    cog = true
}, { __index = BaseFlipGear })
FlipMinicog.__index = FlipMinicog

return FlipMinicog
