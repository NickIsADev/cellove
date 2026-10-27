local BaseGear = require("content/cells/abstract/BaseGear")

local MinigearCW = setmetatable({
    name = "minigear_cw",
    k3 = 108,
    title = "Minigear (CW)",
    description = "Rotates adjacent cells around itself clockwise every tick. Gets jammed by immovable cells and other gears.",
    sides = { orthogonal = true }
}, { __index = BaseGear })
MinigearCW.__index = MinigearCW

return MinigearCW
