local BaseHolder = require("content/cells/abstract/BaseHolder")

local MetaGeneratable = setmetatable({
    name = "metageneratable",
    k3 = 645,
    title = "Metageneratable",
    description = "When generated, the copy's Generation decreases. If it would decrease to 0, it turns into the stored cell instead.",
    subtick = { 0 },
    directional = true
    properties = {
        { id = "generation", title = "Generation", default = 2, min = 1, max = 99 }
    }
}, { __index = BaseHolder })
MetaGeneratable.__index = MetaGeneratable

return MetaGeneratable
