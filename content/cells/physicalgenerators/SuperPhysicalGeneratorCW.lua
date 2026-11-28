local SuperPhysicalGenerator = require("content/cells/physicalgenerators/SuperPhysicalGenerator")

local SuperPhysicalGeneratorCW = setmetatable({
    name = "superphysicalgenerator_cw",
    k3 = 769,
    title = "Super Physical Generator (CW)",
    description = "Super Physical Generator that bends cells clockwise.",
    bend = 1
}, { __index = SuperPhysicalGenerator })
SuperPhysicalGeneratorCW.__index = SuperPhysicalGeneratorCW

return SuperPhysicalGeneratorCW
