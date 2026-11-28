local Generator = require("content/cells/generators/Generator")

local StrongGenerator = setmetatable({
    name = "stronggenerator",
    k3 = 365,
    title = "Strong Generator",
    description = "Generator that pushes with infinite force.",
    pushing = { force = math.huge }
}, { __index = Generator })
StrongGenerator.__index = StrongGenerator

return StrongGenerator
