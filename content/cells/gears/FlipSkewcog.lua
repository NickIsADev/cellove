local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipSkewcog = setmetatable({
    name = "flipskewcog",
    k3 = 1031,
    title = "Flip Skewcog",
    description = "Flips diagonal cells along the direction it faces every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    cog = true
}, { __index = BaseFlipGear })
FlipSkewcog.__index = FlipSkewcog

return FlipSkewcog
