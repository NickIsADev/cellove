local SuperPhysicalBackgenerator = require("content/cells/physicalgenerators/SuperPhysicalBackgenerator")

local SuperPhysicalBackgeneratorCW = setmetatable({
    name = "superphysicalbackgenerator_cw",
    k3 = 773,
    title = "Super Physical Backgenerator (CW)",
    description = "Super Physical Backgenerator that bends cells clockwise.",
    bend = 1
}, { __index = SuperPhysicalBackgenerator })
SuperPhysicalBackgeneratorCW.__index = SuperPhysicalBackgeneratorCW

return SuperPhysicalBackgeneratorCW
