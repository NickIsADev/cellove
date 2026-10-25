local Generator = require("content/cells/generators/Generator")

local DigeneratorCW = setmetatable({
    name = "digenerator_cw",
    k3 = 169,
    title = "Digenerator (CW)",
    description = "Generates a copy forward and to the right.",
    outputs = { 0, 1 },
    aligns = true
}, { __index = Generator })
DigeneratorCW.__index = DigeneratorCW

return DigeneratorCW
