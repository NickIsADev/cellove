local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipSkewgear = setmetatable({
    name = "flipskewgear",
    k3 = 1025,
    title = "Flip Skewgear",
    description = "Flips diagonal cells along the direction it faces every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true }
}, { __index = BaseFlipGear })
FlipSkewgear.__index = FlipSkewgear

return FlipSkewgear
