local BaseGear = require("content/cells/abstract/BaseGear")

local CogCCW = setmetatable({
    name = "cog_ccw",
    k3 = 323,
    title = "Cog (CCW)",
    description = "Rotates surrounding cells around itself counter-clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    spin = -1,
    cog = true
}, { __index = BaseGear })
CogCCW.__index = CogCCW

return CogCCW
