local BaseGear = require("content/cells/abstract/BaseGear")

local Gear180 = setmetatable({
    name = "gear_180",
    k3 = 449,
    title = "Gear (180)",
    description = "Rotates surrounding cells around itself 180 degrees every tick. Gets jammed by immovable cells and other gears.",
    steps = 4,
    turn = 2
}, { __index = BaseGear })
Gear180.__index = Gear180

return Gear180
