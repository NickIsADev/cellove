local SuperTrigenerator = require("content/cells/supergenerators/SuperTrigenerator")

local SuperTricloner = setmetatable({
    name = "supertricloner",
    k3 = 611,
    title = "Super Tricloner",
    description = "Super Trigenerator that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperTrigenerator })
SuperTricloner.__index = SuperTricloner

return SuperTricloner
