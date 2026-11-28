local Builder = require("content/cells/builders/Builder")

local Bibuilder = setmetatable({
    name = "bibuilder",
    k3 = 331,
    title = "Bibuilder",
    description = "Builder with two outputs.",
    outputs = { 3, 1 },
    aligns = true
}, { __index = Builder })
Bibuilder.__index = Bibuilder

return Bibuilder
