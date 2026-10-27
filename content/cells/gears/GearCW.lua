local BaseGear = require("content/cells/abstract/BaseGear")

local GearCW = setmetatable({
    name = "gear_cw",
    k3 = 18,
    title = "Gear (CW)",
    description = "Rotates surrounding cells around itself clockwise every tick. Gets jammed by immovable cells and other gears."
}, { __index = BaseGear })
GearCW.__index = GearCW

return GearCW
