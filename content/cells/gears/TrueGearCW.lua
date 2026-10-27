local BaseTrueGear = require("content/cells/abstract/BaseTrueGear")

local TrueGearCW = setmetatable({
    name = "truegear_cw",
    k3 = 203,
    title = "True Gear (CW)",
    description = "Rotates surrounding cells around itself clockwise every tick. Cannot be pushed, and is never jammed by immovable cells or other gears."
}, { __index = BaseTrueGear })
TrueGearCW.__index = TrueGearCW

return TrueGearCW
