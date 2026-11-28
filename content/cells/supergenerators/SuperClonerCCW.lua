local SuperGeneratorCCW = require("content/cells/supergenerators/SuperGeneratorCCW")

local SuperClonerCCW = setmetatable({
    name = "supercloner_ccw",
    k3 = 461,
    title = "Super Cloner (CCW)",
    description = "Super Generator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperGeneratorCCW })
SuperClonerCCW.__index = SuperClonerCCW

return SuperClonerCCW
