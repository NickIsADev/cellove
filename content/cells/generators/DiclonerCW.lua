local DigeneratorCW = require("content/cells/generators/DigeneratorCW")

local DiclonerCW = setmetatable({
    name = "dicloner_cw",
    k3 = 173,
    title = "Dicloner (CW)",
    description = "Digenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = DigeneratorCW })
DiclonerCW.__index = DiclonerCW

return DiclonerCW
