local CrossReplicator = require("content/cells/replicators/CrossReplicator")

local CrossBackreplicator = setmetatable({
    name = "crossbackreplicator",
    k3 = 868,
    title = "Cross Backreplicator",
    description = "Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = CrossReplicator })
CrossBackreplicator.__index = CrossBackreplicator

return CrossBackreplicator
