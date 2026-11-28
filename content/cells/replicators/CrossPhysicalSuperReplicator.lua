local CrossSuperReplicator = require("content/cells/replicators/CrossSuperReplicator")

local CrossPhysicalSuperReplicator = setmetatable({
    name = "crossphysicalsuperreplicator",
    k3 = 878,
    title = "Cross Physical Super Replicator",
    description = "Super Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = CrossSuperReplicator })
CrossPhysicalSuperReplicator.__index = CrossPhysicalSuperReplicator

return CrossPhysicalSuperReplicator
