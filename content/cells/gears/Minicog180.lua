local BaseGear = require("content/cells/abstract/BaseGear")

local Minicog180 = setmetatable({
    name = "minicog_180",
    k3 = 452,
    title = "Minicog (180)",
    description = "Rotates adjacent cells around itself 180 degrees every tick. Does not rotate the cells themselves. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    steps = 2,
    cog = true
}, { __index = BaseGear })
Minicog180.__index = Minicog180

return Minicog180
