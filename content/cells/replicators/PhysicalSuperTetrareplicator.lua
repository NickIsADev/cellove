local SuperTetrareplicator = require("content/cells/replicators/SuperTetrareplicator")

local PhysicalSuperTetrareplicator = setmetatable({
    name = "physicalsupertetrareplicator",
    k3 = 887,
    title = "Physical Super Tetrareplicator",
    description = "Super Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = SuperTetrareplicator })
PhysicalSuperTetrareplicator.__index = PhysicalSuperTetrareplicator

return PhysicalSuperTetrareplicator
