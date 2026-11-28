local SuperPhysicalBackgeneratorCCW = require("content/cells/physicalgenerators/SuperPhysicalBackgeneratorCCW")

local SuperPhysicalBackclonerCCW = setmetatable({
    name = "superphysicalbackcloner_ccw",
    k3 = 776,
    title = "Super Physical Backcloner (CCW)",
    description = "Super Physical Backgenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperPhysicalBackgeneratorCCW })
SuperPhysicalBackclonerCCW.__index = SuperPhysicalBackclonerCCW

return SuperPhysicalBackclonerCCW
