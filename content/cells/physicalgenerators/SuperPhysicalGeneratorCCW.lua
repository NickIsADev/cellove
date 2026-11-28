local SuperPhysicalGenerator = require("content/cells/physicalgenerators/SuperPhysicalGenerator")

local SuperPhysicalGeneratorCCW = setmetatable({
    name = "superphysicalgenerator_ccw",
    k3 = 770,
    title = "Super Physical Generator (CCW)",
    description = "Super Physical Generator that bends cells counter-clockwise.",
    bend = -1
}, { __index = SuperPhysicalGenerator })
SuperPhysicalGeneratorCCW.__index = SuperPhysicalGeneratorCCW

return SuperPhysicalGeneratorCCW
