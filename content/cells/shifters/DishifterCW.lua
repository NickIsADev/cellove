local Shifter = require("content/cells/shifters/Shifter")

local DishifterCW = setmetatable({
    name = "dishifter_cw",
    k3 = 259,
    title = "Dishifter (CW)",
    description = "Shifter that outputs forward and clockwise at once.",
    outputs = { 0, 1 },
    rear = true
}, { __index = Shifter })
DishifterCW.__index = DishifterCW

return DishifterCW
