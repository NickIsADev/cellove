local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Ungrabbable = setmetatable({
    name = "ungrabbable",
    k3 = 698,
    title = "Ungrabbable",
    description = "Cannot be grabbed.",
    guards = { grab = true }
}, { __index = BaseOpposition })
Ungrabbable.__index = Ungrabbable

return Ungrabbable
