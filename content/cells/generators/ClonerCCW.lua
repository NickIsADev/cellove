local GeneratorCCW = require("content/cells/generators/GeneratorCCW")

local ClonerCCW = setmetatable({
    name = "cloner_ccw",
    k3 = 111,
    title = "Cloner (CCW)",
    description = "Generator (CCW) that does not rotate the generated cell.",
    rotates = false
}, { __index = GeneratorCCW })
ClonerCCW.__index = ClonerCCW

return ClonerCCW
