local BaseGear = require("content/cells/abstract/BaseGear")

local FasterCogCW = setmetatable({
    name = "fastercog_cw",
    k3 = 475,
    title = "Faster Cog (CW)",
    description = "Rotates surrounding cells around itself 135 degrees clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    steps = 3,
    cog = true
}, { __index = BaseGear })
FasterCogCW.__index = FasterCogCW

return FasterCogCW
