local Builder = require("content/cells/builders/Builder")

local CrossBuilder = setmetatable({
    name = "crossbuilder",
    k3 = 328,
    title = "Cross Builder",
    description = "Two Builders combined.",
    outputs = { 0, 3 }
}, { __index = Builder })
CrossBuilder.__index = CrossBuilder

function CrossBuilder:_entry(output)
    return output
end

return CrossBuilder
