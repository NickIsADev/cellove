local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local SuperBackreplicator = setmetatable({
    name = "superbackreplicator",
    k3 = 678,
    title = "Super Backreplicator",
    description = "Super Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = SuperReplicator })
SuperBackreplicator.__index = SuperBackreplicator

return SuperBackreplicator
