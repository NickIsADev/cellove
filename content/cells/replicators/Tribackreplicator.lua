local Trireplicator = require("content/cells/replicators/Trireplicator")

local Tribackreplicator = setmetatable({
    name = "tribackreplicator",
    k3 = 874,
    title = "Tribackreplicator",
    description = "Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = Trireplicator })
Tribackreplicator.__index = Tribackreplicator

return Tribackreplicator
