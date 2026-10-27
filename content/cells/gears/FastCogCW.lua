local BaseGear = require("content/cells/abstract/BaseGear")

local FastCogCW = setmetatable({
    name = "fastcog_cw",
    k3 = 471,
    title = "Fast Cog (CW)",
    description = "Rotates surrounding cells around itself 90 degrees clockwise every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    steps = 2,
    cog = true
}, { __index = BaseGear })
FastCogCW.__index = FastCogCW

return FastCogCW
