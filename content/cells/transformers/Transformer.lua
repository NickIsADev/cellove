local BaseTransformer = require("content/cells/abstract/BaseTransformer")

local Transformer = setmetatable({
    name = "transformer",
    k3 = 237,
    title = "Transformer",
    description = "Transforms the cell in front of it into a copy of the cell behind it."
}, { __index = BaseTransformer })
Transformer.__index = Transformer

return Transformer
