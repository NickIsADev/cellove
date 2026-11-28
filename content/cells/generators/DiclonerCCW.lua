local DigeneratorCCW = require("content/cells/generators/DigeneratorCCW")

local DiclonerCCW = setmetatable({
    name = "dicloner_ccw",
    k3 = 174,
    title = "Dicloner (CCW)",
    description = "Digenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = DigeneratorCCW })
DiclonerCCW.__index = DiclonerCCW

return DiclonerCCW
