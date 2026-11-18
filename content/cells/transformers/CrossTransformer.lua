local Transformer = require("content/cells/transformers/Transformer")

local CrossTransformer = setmetatable({
    name = "crosstransformer",
    k3 = 238,
    title = "Cross Transformer",
    description = "Two Transformers in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = Transformer })
CrossTransformer.__index = CrossTransformer

return CrossTransformer
