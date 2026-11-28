local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperDigeneratorCW = setmetatable({
    name = "superdigenerator_cw",
    k3 = 608,
    title = "Super Digenerator (CW)",
    description = "Digenerator (CW) that generates entire rows.",
    outputs = { 0, 1 },
    aligns = true
}, { __index = SuperGenerator })
SuperDigeneratorCW.__index = SuperDigeneratorCW

return SuperDigeneratorCW
