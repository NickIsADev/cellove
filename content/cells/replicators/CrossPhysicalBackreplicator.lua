local CrossReplicator = require("content/cells/replicators/CrossReplicator")

local CrossPhysicalBackreplicator = setmetatable({
    name = "crossphysicalbackreplicator",
    k3 = 867,
    title = "Cross Physical Backreplicator",
    description = "Replicator that moves backwards to replicate, or acts like a Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = CrossReplicator })
CrossPhysicalBackreplicator.__index = CrossPhysicalBackreplicator

return CrossPhysicalBackreplicator
