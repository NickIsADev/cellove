local BaseGear = require("content/cells/abstract/BaseGear")

local MinicogRNG = setmetatable({
    name = "minicog_rng",
    k3 = 976,
    title = "Minicog (RNG)",
    description = "Rotates adjacent cells around itself clockwise or counter-clockwise at random every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    random = true,
    cog = true
}, { __index = BaseGear })
MinicogRNG.__index = MinicogRNG

return MinicogRNG
