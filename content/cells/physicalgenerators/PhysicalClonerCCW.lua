local PhysicalGeneratorCCW = require("content/cells/physicalgenerators/PhysicalGeneratorCCW")

local PhysicalClonerCCW = setmetatable({
    name = "physicalcloner_ccw",
    k3 = 752,
    title = "Physical Cloner (CCW)",
    description = "Physical Generator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = PhysicalGeneratorCCW })
PhysicalClonerCCW.__index = PhysicalClonerCCW

return PhysicalClonerCCW
