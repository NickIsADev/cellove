local BaseGear = require("content/cells/abstract/BaseGear")

local FasterCogCCW = setmetatable({
    name = "fastercog_ccw",
    k3 = 476,
    title = "Faster Cog (CCW)",
    description = "Rotates surrounding cells around itself 135 degrees counter-clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    spin = -1,
    steps = 3,
    cog = true
}, { __index = BaseGear })
FasterCogCCW.__index = FasterCogCCW

return FasterCogCCW
