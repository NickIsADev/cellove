local BaseGear = require("content/cells/abstract/BaseGear")

local MinicogCW = setmetatable({
    name = "minicog_cw",
    k3 = 324,
    title = "Minicog (CW)",
    description = "Rotates adjacent cells around itself clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    cog = true
}, { __index = BaseGear })
MinicogCW.__index = MinicogCW

return MinicogCW
