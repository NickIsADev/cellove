local SuperDigeneratorCCW = require("content/cells/supergenerators/SuperDigeneratorCCW")

local SuperDiclonerCCW = setmetatable({
    name = "superdicloner_ccw",
    k3 = 613,
    title = "Super Dicloner (CCW)",
    description = "Super Digenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperDigeneratorCCW })
SuperDiclonerCCW.__index = SuperDiclonerCCW

return SuperDiclonerCCW
