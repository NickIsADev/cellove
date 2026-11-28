local SuperTetrareplicator = require("content/cells/replicators/SuperTetrareplicator")

local PhysicalSuperTetrabackreplicator = setmetatable({
    name = "physicalsupertetrabackreplicator",
    k3 = 888,
    title = "Physical Super Tetrabackreplicator",
    description = "Super Replicator that moves backwards to replicate, or acts like a Super Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = SuperTetrareplicator })
PhysicalSuperTetrabackreplicator.__index = PhysicalSuperTetrabackreplicator

return PhysicalSuperTetrabackreplicator
