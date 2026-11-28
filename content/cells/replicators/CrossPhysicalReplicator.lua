local CrossReplicator = require("content/cells/replicators/CrossReplicator")

local CrossPhysicalReplicator = setmetatable({
    name = "crossphysicalreplicator",
    k3 = 866,
    title = "Cross Physical Replicator",
    description = "Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = CrossReplicator })
CrossPhysicalReplicator.__index = CrossPhysicalReplicator

return CrossPhysicalReplicator
