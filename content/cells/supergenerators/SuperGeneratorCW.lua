local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperGeneratorCW = setmetatable({
    name = "supergenerator_cw",
    k3 = 458,
    title = "Super Generator (CW)",
    description = "Super Generator that bends cells clockwise.",
    bend = 1
}, { __index = SuperGenerator })
SuperGeneratorCW.__index = SuperGeneratorCW

return SuperGeneratorCW
