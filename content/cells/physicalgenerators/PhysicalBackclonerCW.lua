local PhysicalBackgeneratorCW = require("content/cells/physicalgenerators/PhysicalBackgeneratorCW")

local PhysicalBackclonerCW = setmetatable({
    name = "physicalbackcloner_cw",
    k3 = 755,
    title = "Physical Backcloner (CW)",
    description = "Physical Backgenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = PhysicalBackgeneratorCW })
PhysicalBackclonerCW.__index = PhysicalBackclonerCW

return PhysicalBackclonerCW
