local PhysicalBackgenerator = require("content/cells/physicalgenerators/PhysicalBackgenerator")

local PhysicalBackgeneratorCCW = setmetatable({
    name = "physicalbackgenerator_ccw",
    k3 = 754,
    title = "Physical Backgenerator (CCW)",
    description = "Physical Backgenerator that bends cells counter-clockwise.",
    bend = -1
}, { __index = PhysicalBackgenerator })
PhysicalBackgeneratorCCW.__index = PhysicalBackgeneratorCCW

return PhysicalBackgeneratorCCW
