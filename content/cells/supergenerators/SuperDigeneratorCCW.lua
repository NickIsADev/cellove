local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperDigeneratorCCW = setmetatable({
    name = "superdigenerator_ccw",
    k3 = 609,
    title = "Super Digenerator (CCW)",
    description = "Digenerator (CCW) that generates entire rows.",
    outputs = { 0, 3 },
    aligns = true
}, { __index = SuperGenerator })
SuperDigeneratorCCW.__index = SuperDigeneratorCCW

return SuperDigeneratorCCW
