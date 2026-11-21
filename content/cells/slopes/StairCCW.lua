local Stair = require("content/cells/slopes/Stair")

local StairCCW = setmetatable({
    name = "stair_ccw",
    k3 = 392,
    title = "Stair (CCW)",
    description = "Stair that always shifts cells counter-clockwise.",
    sense = "ccw",
    faces = {}
}, { __index = Stair })
StairCCW.__index = StairCCW

return StairCCW
