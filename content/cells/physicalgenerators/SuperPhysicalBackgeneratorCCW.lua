local SuperPhysicalBackgenerator = require("content/cells/physicalgenerators/SuperPhysicalBackgenerator")

local SuperPhysicalBackgeneratorCCW = setmetatable({
    name = "superphysicalbackgenerator_ccw",
    k3 = 774,
    title = "Super Physical Backgenerator (CCW)",
    description = "Super Physical Backgenerator that bends cells counter-clockwise.",
    bend = -1
}, { __index = SuperPhysicalBackgenerator })
SuperPhysicalBackgeneratorCCW.__index = SuperPhysicalBackgeneratorCCW

return SuperPhysicalBackgeneratorCCW
