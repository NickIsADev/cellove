local SuperPhysicalGeneratorCW = require("content/cells/physicalgenerators/SuperPhysicalGeneratorCW")

local SuperPhysicalClonerCW = setmetatable({
    name = "superphysicalcloner_cw",
    k3 = 771,
    title = "Super Physical Cloner (CW)",
    description = "Super Physical Generator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperPhysicalGeneratorCW })
SuperPhysicalClonerCW.__index = SuperPhysicalClonerCW

return SuperPhysicalClonerCW
