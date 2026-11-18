local Shifter = require("content/cells/shifters/Shifter")

local DishifterCCW = setmetatable({
    name = "dishifter_ccw",
    k3 = 258,
    title = "Dishifter (CCW)",
    description = "Shifter that outputs forward and counter-clockwise at once.",
    outputs = { 0, 3 },
    rear = true
}, { __index = Shifter })
DishifterCCW.__index = DishifterCCW

return DishifterCCW
