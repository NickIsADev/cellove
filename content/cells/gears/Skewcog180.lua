local BaseGear = require("content/cells/abstract/BaseGear")

local Skewcog180 = setmetatable({
    name = "skewcog_180",
    k3 = 487,
    title = "Skewcog (180)",
    description = "Rotates diagonal cells around itself 180 degrees every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    steps = 2,
    cog = true
}, { __index = BaseGear })
Skewcog180.__index = Skewcog180

return Skewcog180
