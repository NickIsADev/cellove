local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local PhysicalSuperReplicator = setmetatable({
    name = "physicalsuperreplicator",
    k3 = 676,
    title = "Physical Super Replicator",
    description = "Super Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = SuperReplicator })
PhysicalSuperReplicator.__index = PhysicalSuperReplicator

return PhysicalSuperReplicator
