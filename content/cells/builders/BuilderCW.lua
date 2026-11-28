local Builder = require("content/cells/builders/Builder")

local BuilderCW = setmetatable({
    name = "builder_cw",
    k3 = 329,
    title = "Builder (CW)",
    description = "Builder that bends cells clockwise.",
    entry = 3,
    bend = 1
}, { __index = Builder })
BuilderCW.__index = BuilderCW

return BuilderCW
