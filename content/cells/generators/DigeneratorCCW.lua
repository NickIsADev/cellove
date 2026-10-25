local Generator = require("content/cells/generators/Generator")

local DigeneratorCCW = setmetatable({
    name = "digenerator_ccw",
    k3 = 170,
    title = "Digenerator (CCW)",
    description = "Generates a copy forward and to the left.",
    outputs = { 0, 3 },
    aligns = true
}, { __index = Generator })
DigeneratorCCW.__index = DigeneratorCCW

return DigeneratorCCW
