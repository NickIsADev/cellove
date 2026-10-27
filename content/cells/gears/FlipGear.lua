local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipGear = setmetatable({
    name = "flipgear",
    k3 = 1021,
    title = "Flip Gear",
    description = "Flips surrounding cells along the direction it faces every tick. Gets jammed by immovable cells and other gears."
}, { __index = BaseFlipGear })
FlipGear.__index = FlipGear

return FlipGear
