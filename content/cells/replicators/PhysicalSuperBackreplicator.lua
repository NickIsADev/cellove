local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local PhysicalSuperBackreplicator = setmetatable({
    name = "physicalsuperbackreplicator",
    k3 = 677,
    title = "Physical Super Backreplicator",
    description = "Super Replicator that moves backwards to replicate, or acts like a Super Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = SuperReplicator })
PhysicalSuperBackreplicator.__index = PhysicalSuperBackreplicator

return PhysicalSuperBackreplicator
