local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Unswappable = setmetatable({
    name = "unswappable",
    k3 = 699,
    title = "Unswappable",
    description = "Cannot be swapped.",
    guards = { swap = true }
}, { __index = BaseOpposition })
Unswappable.__index = Unswappable

return Unswappable
