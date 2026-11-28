local SuperGeneratorCW = require("content/cells/supergenerators/SuperGeneratorCW")

local SuperClonerCW = setmetatable({
    name = "supercloner_cw",
    k3 = 460,
    title = "Super Cloner (CW)",
    description = "Super Generator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperGeneratorCW })
SuperClonerCW.__index = SuperClonerCW

return SuperClonerCW
