local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Untunnellable = setmetatable({
    name = "untunnellable",
    k3 = 937,
    title = "Untunnellable",
    description = "Cannot be tunnelled through by drillers.",
    guards = { tunnel = true }
}, { __index = BaseOpposition })
Untunnellable.__index = Untunnellable

return Untunnellable
