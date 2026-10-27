local BaseGear = require("content/cells/abstract/BaseGear")

local Skewgear180 = setmetatable({
    name = "skewgear_180",
    k3 = 484,
    title = "Skewgear (180)",
    description = "Rotates diagonal cells around itself 180 degrees every tick. Gets jammed by immovable cells and other gears.",
    sides = { diagonal = true },
    steps = 2
}, { __index = BaseGear })
Skewgear180.__index = Skewgear180

return Skewgear180
