local PhysicalGeneratorCW = require("content/cells/physicalgenerators/PhysicalGeneratorCW")

local PhysicalClonerCW = setmetatable({
    name = "physicalcloner_cw",
    k3 = 751,
    title = "Physical Cloner (CW)",
    description = "Physical Generator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = PhysicalGeneratorCW })
PhysicalClonerCW.__index = PhysicalClonerCW

return PhysicalClonerCW
