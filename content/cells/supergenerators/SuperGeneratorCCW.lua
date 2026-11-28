local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperGeneratorCCW = setmetatable({
    name = "supergenerator_ccw",
    k3 = 459,
    title = "Super Generator (CCW)",
    description = "Super Generator that bends cells counter-clockwise.",
    bend = -1
}, { __index = SuperGenerator })
SuperGeneratorCCW.__index = SuperGeneratorCCW

return SuperGeneratorCCW
