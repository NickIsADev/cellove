local Generator = require("content/cells/generators/Generator")

local Bigenerator = setmetatable({
    name = "bigenerator",
    k3 = 168,
    title = "Bigenerator",
    description = "Generates a copy on each side.",
    outputs = { 1, 3 },
    aligns = true
}, { __index = Generator })
Bigenerator.__index = Bigenerator

return Bigenerator
