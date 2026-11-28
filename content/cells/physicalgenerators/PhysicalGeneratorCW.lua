local PhysicalGenerator = require("content/cells/physicalgenerators/PhysicalGenerator")

local PhysicalGeneratorCW = setmetatable({
    name = "physicalgenerator_cw",
    k3 = 749,
    title = "Physical Generator (CW)",
    description = "Physical Generator that bends cells clockwise.",
    bend = 1
}, { __index = PhysicalGenerator })
PhysicalGeneratorCW.__index = PhysicalGeneratorCW

return PhysicalGeneratorCW
