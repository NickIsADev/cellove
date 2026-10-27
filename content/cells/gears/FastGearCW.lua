local BaseGear = require("content/cells/abstract/BaseGear")

local FastGearCW = setmetatable({
    name = "fastgear_cw",
    k3 = 469,
    title = "Fast Gear (CW)",
    description = "Rotates surrounding cells around itself 90 degrees clockwise every tick. Gets jammed by immovable cells and other gears.",
    steps = 2
}, { __index = BaseGear })
FastGearCW.__index = FastGearCW

return FastGearCW
