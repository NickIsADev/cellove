local Generator = require("content/cells/generators/Generator")

local GeneratorCW = setmetatable({
    name = "generator_cw",
    k3 = 26,
    title = "Generator (CW)",
    description = "Generator that bends cells clockwise.",
    bend = 1
}, { __index = Generator })
GeneratorCW.__index = GeneratorCW

return GeneratorCW
