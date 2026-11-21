local Slope = require("content/cells/slopes/Slope")

local SlopeCW = setmetatable({
    name = "slope_cw",
    k3 = 382,
    title = "Slope (CW)",
    description = "Slope that always shifts cells clockwise.",
    sense = "cw",
    faces = {}
}, { __index = Slope })
SlopeCW.__index = SlopeCW

return SlopeCW
