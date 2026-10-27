local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipCog = setmetatable({
    name = "flipcog",
    k3 = 1027,
    title = "Flip Cog",
    description = "Flips surrounding cells along the direction it faces every tick. Does not flip the cells themselves. Gets jammed by immovable cells and other gears.",
    cog = true
}, { __index = BaseFlipGear })
FlipCog.__index = FlipCog

return FlipCog
