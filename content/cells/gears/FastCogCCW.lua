local BaseGear = require("content/cells/abstract/BaseGear")

local FastCogCCW = setmetatable({
    name = "fastcog_ccw",
    k3 = 472,
    title = "Fast Cog (CCW)",
    description = "Rotates surrounding cells around itself 90 degrees counter-clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    spin = -1,
    steps = 2,
    cog = true
}, { __index = BaseGear })
FastCogCCW.__index = FastCogCCW

return FastCogCCW
