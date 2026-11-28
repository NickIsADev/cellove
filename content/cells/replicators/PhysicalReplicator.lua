local Replicator = require("content/cells/replicators/Replicator")

local PhysicalReplicator = setmetatable({
    name = "physicalreplicator",
    k3 = 343,
    title = "Physical Replicator",
    description = "Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = Replicator })
PhysicalReplicator.__index = PhysicalReplicator

return PhysicalReplicator
