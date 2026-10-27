local BaseGear = require("content/cells/abstract/BaseGear")

local Minigear180 = setmetatable({
    name = "minigear_180",
    k3 = 450,
    title = "Minigear (180)",
    description = "Rotates adjacent cells around itself 180 degrees every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    steps = 2
}, { __index = BaseGear })
Minigear180.__index = Minigear180

return Minigear180
