local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local CrossSuperReplicator = setmetatable({
    name = "crosssuperreplicator",
    k3 = 513,
    title = "Cross Super Replicator",
    description = "Two Super Replicators.",
    outputs = { 0, 3 }
}, { __index = SuperReplicator })
CrossSuperReplicator.__index = CrossSuperReplicator

return CrossSuperReplicator
