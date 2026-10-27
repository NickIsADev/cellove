local BaseGear = require("content/cells/abstract/BaseGear")

local CogCW = setmetatable({
    name = "cog_cw",
    k3 = 322,
    title = "Cog (CW)",
    description = "Rotates surrounding cells around itself clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    cog = true
}, { __index = BaseGear })
CogCW.__index = CogCW

return CogCW
