local BaseFlipGear = require("content/cells/abstract/BaseFlipGear")

local FlipMinigear = setmetatable({
    name = "flipminigear",
    k3 = 1023,
    title = "Flip Minigear",
    description = "Flips adjacent cells along the direction it faces every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true }
}, { __index = BaseFlipGear })
FlipMinigear.__index = FlipMinigear

return FlipMinigear
