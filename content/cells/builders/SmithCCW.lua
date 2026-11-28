local BuilderCCW = require("content/cells/builders/BuilderCCW")

local SmithCCW = setmetatable({
    name = "smith_ccw",
    k3 = 336,
    title = "Smith (CCW)",
    description = "Builder (CCW) that does not rotate cells.",
    rotates = false
}, { __index = BuilderCCW })
SmithCCW.__index = SmithCCW

return SmithCCW
