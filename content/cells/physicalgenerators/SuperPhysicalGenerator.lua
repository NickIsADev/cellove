local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperPhysicalGenerator = setmetatable({
    name = "superphysicalgenerator",
    k3 = 673,
    title = "Super Physical Generator",
    description = "When blocked from generating, it attempts to move backwards to generate.",
    categories = { "physicalgenerators" },
    retreat = "blocked"
}, { __index = SuperGenerator })
SuperPhysicalGenerator.__index = SuperPhysicalGenerator

return SuperPhysicalGenerator
