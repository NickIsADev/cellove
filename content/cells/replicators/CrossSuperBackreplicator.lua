local CrossSuperReplicator = require("content/cells/replicators/CrossSuperReplicator")

local CrossSuperBackreplicator = setmetatable({
    name = "crosssuperbackreplicator",
    k3 = 880,
    title = "Cross Super Backreplicator",
    description = "Super Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = CrossSuperReplicator })
CrossSuperBackreplicator.__index = CrossSuperBackreplicator

return CrossSuperBackreplicator
