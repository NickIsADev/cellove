local Generator = require("content/cells/generators/Generator")

local Trigenerator = setmetatable({
    name = "trigenerator",
    k3 = 167,
    title = "Trigenerator",
    description = "Generates a copy forward and on each side.",
    outputs = { 0, 1, 3 },
    aligns = true
}, { __index = Generator })
Trigenerator.__index = Trigenerator

return Trigenerator
