local PhysicalBackgeneratorCCW = require("content/cells/physicalgenerators/PhysicalBackgeneratorCCW")

local PhysicalBackclonerCCW = setmetatable({
    name = "physicalbackcloner_ccw",
    k3 = 756,
    title = "Physical Backcloner (CCW)",
    description = "Physical Backgenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = PhysicalBackgeneratorCCW })
PhysicalBackclonerCCW.__index = PhysicalBackclonerCCW

return PhysicalBackclonerCCW
