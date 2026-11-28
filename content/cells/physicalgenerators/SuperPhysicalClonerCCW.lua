local SuperPhysicalGeneratorCCW = require("content/cells/physicalgenerators/SuperPhysicalGeneratorCCW")

local SuperPhysicalClonerCCW = setmetatable({
    name = "superphysicalcloner_ccw",
    k3 = 772,
    title = "Super Physical Cloner (CCW)",
    description = "Super Physical Generator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperPhysicalGeneratorCCW })
SuperPhysicalClonerCCW.__index = SuperPhysicalClonerCCW

return SuperPhysicalClonerCCW
