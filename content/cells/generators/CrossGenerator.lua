local Generator = require("content/cells/generators/Generator")

local CrossGenerator = setmetatable({
    name = "crossgenerator",
    k3 = 23,
    title = "Cross Generator",
    description = "Two generators in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = Generator })
CrossGenerator.__index = CrossGenerator

return CrossGenerator
