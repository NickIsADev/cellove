local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Unpushable = setmetatable({
    name = "unpushable",
    k3 = 696,
    title = "Unpushable",
    description = "Cannot be pushed.",
    guards = { push = true }
}, { __index = BaseOpposition })
Unpushable.__index = Unpushable

return Unpushable
