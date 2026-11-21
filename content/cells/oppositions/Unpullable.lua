local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Unpullable = setmetatable({
    name = "unpullable",
    k3 = 697,
    title = "Unpullable",
    description = "Cannot be pulled.",
    guards = { pull = true }
}, { __index = BaseOpposition })
Unpullable.__index = Unpullable

return Unpullable
