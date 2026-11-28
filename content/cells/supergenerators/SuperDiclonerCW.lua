local SuperDigeneratorCW = require("content/cells/supergenerators/SuperDigeneratorCW")

local SuperDiclonerCW = setmetatable({
    name = "superdicloner_cw",
    k3 = 612,
    title = "Super Dicloner (CW)",
    description = "Super Digenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperDigeneratorCW })
SuperDiclonerCW.__index = SuperDiclonerCW

return SuperDiclonerCW
