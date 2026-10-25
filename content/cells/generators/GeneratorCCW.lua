local Generator = require("content/cells/generators/Generator")

local GeneratorCCW = setmetatable({
    name = "generator_ccw",
    k3 = 27,
    title = "Generator (CCW)",
    description = "Generator that bends cells counter-clockwise.",
    bend = -1
}, { __index = Generator })
GeneratorCCW.__index = GeneratorCCW

return GeneratorCCW
