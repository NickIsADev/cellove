local BaseGear = require("content/cells/abstract/BaseGear")

local MinicogCCW = setmetatable({
    name = "minicog_ccw",
    k3 = 325,
    title = "Minicog (CCW)",
    description = "Rotates adjacent cells around itself counter-clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    spin = -1,
    cog = true
}, { __index = BaseGear })
MinicogCCW.__index = MinicogCCW

return MinicogCCW
