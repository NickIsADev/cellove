local SuperPhysicalBackgeneratorCW = require("content/cells/physicalgenerators/SuperPhysicalBackgeneratorCW")

local SuperPhysicalBackclonerCW = setmetatable({
    name = "superphysicalbackcloner_cw",
    k3 = 775,
    title = "Super Physical Backcloner (CW)",
    description = "Super Physical Backgenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperPhysicalBackgeneratorCW })
SuperPhysicalBackclonerCW.__index = SuperPhysicalBackclonerCW

return SuperPhysicalBackclonerCW
