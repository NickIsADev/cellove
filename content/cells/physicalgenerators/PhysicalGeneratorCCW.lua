local PhysicalGenerator = require("content/cells/physicalgenerators/PhysicalGenerator")

local PhysicalGeneratorCCW = setmetatable({
    name = "physicalgenerator_ccw",
    k3 = 750,
    title = "Physical Generator (CCW)",
    description = "Physical Generator that bends cells counter-clockwise.",
    bend = -1
}, { __index = PhysicalGenerator })
PhysicalGeneratorCCW.__index = PhysicalGeneratorCCW

return PhysicalGeneratorCCW
