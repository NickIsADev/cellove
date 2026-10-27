local BaseGear = require("content/cells/abstract/BaseGear")

local MinigearRNG = setmetatable({
    name = "minigear_rng",
    k3 = 971,
    title = "Minigear (RNG)",
    description = "Rotates adjacent cells around itself clockwise or counter-clockwise at random every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    random = true
}, { __index = BaseGear })
MinigearRNG.__index = MinigearRNG

return MinigearRNG
