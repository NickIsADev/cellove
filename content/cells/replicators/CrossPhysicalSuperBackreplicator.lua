local CrossSuperReplicator = require("content/cells/replicators/CrossSuperReplicator")

local CrossPhysicalSuperBackreplicator = setmetatable({
    name = "crossphysicalsuperbackreplicator",
    k3 = 879,
    title = "Cross Physical Super Backreplicator",
    description = "Super Replicator that moves backwards to replicate, or acts like a Super Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = CrossSuperReplicator })
CrossPhysicalSuperBackreplicator.__index = CrossPhysicalSuperBackreplicator

return CrossPhysicalSuperBackreplicator
