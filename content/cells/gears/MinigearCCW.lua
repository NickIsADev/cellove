local BaseGear = require("content/cells/abstract/BaseGear")

local MinigearCCW = setmetatable({
    name = "minigear_ccw",
    k3 = 109,
    title = "Minigear (CCW)",
    description = "Rotates adjacent cells around itself counter-clockwise every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true },
    spin = -1
}, { __index = BaseGear })
MinigearCCW.__index = MinigearCCW

return MinigearCCW
