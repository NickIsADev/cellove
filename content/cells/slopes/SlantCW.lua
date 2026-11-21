local Slant = require("content/cells/slopes/Slant")

local SlantCW = setmetatable({
    name = "slant_cw",
    k3 = 1018,
    title = "Slant (CW)",
    description = "Slant that always shifts cells clockwise.",
    sense = "cw",
    faces = {}
}, { __index = Slant })
SlantCW.__index = SlantCW

return SlantCW
