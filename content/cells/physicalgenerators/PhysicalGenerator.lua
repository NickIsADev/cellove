local Generator = require("content/cells/generators/Generator")

local PhysicalGenerator = setmetatable({
    name = "physicalgenerator",
    k3 = 342,
    title = "Physical Generator",
    description = "When blocked from generating, it attempts to move backwards to generate.",
    categories = { "physicalgenerators" },
    retreat = "blocked"
}, { __index = Generator })
PhysicalGenerator.__index = PhysicalGenerator

return PhysicalGenerator
