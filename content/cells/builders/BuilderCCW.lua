local Builder = require("content/cells/builders/Builder")

local BuilderCCW = setmetatable({
    name = "builder_ccw",
    k3 = 330,
    title = "Builder (CCW)",
    description = "Builder that bends cells counter-clockwise.",
    entry = 1,
    bend = -1
}, { __index = Builder })
BuilderCCW.__index = BuilderCCW

return BuilderCCW
