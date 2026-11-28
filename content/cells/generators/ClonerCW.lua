local GeneratorCW = require("content/cells/generators/GeneratorCW")

local ClonerCW = setmetatable({
    name = "cloner_cw",
    k3 = 110,
    title = "Cloner (CW)",
    description = "Generator (CW) that does not rotate the generated cell.",
    rotates = false
}, { __index = GeneratorCW })
ClonerCW.__index = ClonerCW

return ClonerCW
