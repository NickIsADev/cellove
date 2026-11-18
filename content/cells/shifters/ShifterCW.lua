local Shifter = require("content/cells/shifters/Shifter")

local ShifterCW = setmetatable({
    name = "shifter_cw",
    k3 = 254,
    title = "Shifter (CW)",
    description = "Shifter that bends cells clockwise.",
    bend = 1
}, { __index = Shifter })
ShifterCW.__index = ShifterCW

return ShifterCW
