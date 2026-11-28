local Tetrareplicator = require("content/cells/replicators/Tetrareplicator")

local PhysicalTetrabackreplicator = setmetatable({
    name = "physicaltetrabackreplicator",
    k3 = 876,
    title = "Physical Tetrabackreplicator",
    description = "Replicator that moves backwards to replicate, or acts like a Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = Tetrareplicator })
PhysicalTetrabackreplicator.__index = PhysicalTetrabackreplicator

return PhysicalTetrabackreplicator
