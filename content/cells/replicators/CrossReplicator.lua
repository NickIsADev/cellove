local Replicator = require("content/cells/replicators/Replicator")

local CrossReplicator = setmetatable({
    name = "crossreplicator",
    k3 = 46,
    title = "Cross Replicator",
    description = "Two Replicators combined.",
    outputs = { 0, 3 }
}, { __index = Replicator })
CrossReplicator.__index = CrossReplicator

return CrossReplicator
