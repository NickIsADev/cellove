local Builder = require("content/cells/builders/Builder")

local Tribuilder = setmetatable({
    name = "tribuilder",
    k3 = 332,
    title = "Tribuilder",
    description = "Builder with three outputs.",
    outputs = { 0, 3, 1 },
    aligns = true
}, { __index = Builder })
Tribuilder.__index = Tribuilder

return Tribuilder
