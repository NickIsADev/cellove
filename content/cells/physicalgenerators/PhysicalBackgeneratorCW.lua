local PhysicalBackgenerator = require("content/cells/physicalgenerators/PhysicalBackgenerator")

local PhysicalBackgeneratorCW = setmetatable({
    name = "physicalbackgenerator_cw",
    k3 = 753,
    title = "Physical Backgenerator (CW)",
    description = "Physical Backgenerator that bends cells clockwise.",
    bend = 1
}, { __index = PhysicalBackgenerator })
PhysicalBackgeneratorCW.__index = PhysicalBackgeneratorCW

return PhysicalBackgeneratorCW
