local BaseGear = require("content/cells/abstract/BaseGear")

local Cog180 = setmetatable({
    name = "cog_180",
    k3 = 451,
    title = "Cog (180)",
    description = "Rotates surrounding cells around itself 180 degrees every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    steps = 4,
    turn = 2,
    cog = true
}, { __index = BaseGear })
Cog180.__index = Cog180

return Cog180
