local Stair = require("content/cells/slopes/Stair")

local StairCW = setmetatable({
    name = "stair_cw",
    k3 = 391,
    title = "Stair (CW)",
    description = "Stair that always shifts cells clockwise.",
    sense = "cw",
    faces = {}
}, { __index = Stair })
StairCW.__index = StairCW

return StairCW
