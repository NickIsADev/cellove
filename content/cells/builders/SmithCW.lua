local BuilderCW = require("content/cells/builders/BuilderCW")

local SmithCW = setmetatable({
    name = "smith_cw",
    k3 = 335,
    title = "Smith (CW)",
    description = "Builder (CW) that does not rotate cells.",
    rotates = false
}, { __index = BuilderCW })
SmithCW.__index = SmithCW

return SmithCW
