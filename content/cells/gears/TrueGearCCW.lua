local BaseTrueGear = require("content/cells/abstract/BaseTrueGear")

local TrueGearCCW = setmetatable({
    name = "truegear_ccw",
    k3 = 204,
    title = "True Gear (CCW)",
    description = "Rotates surrounding cells around itself counter-clockwise every tick. Cannot be pushed, and is never jammed by immovable cells or other gears.",
    spin = -1
}, { __index = BaseTrueGear })
TrueGearCCW.__index = TrueGearCCW

return TrueGearCCW
