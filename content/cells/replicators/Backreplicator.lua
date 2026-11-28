local Replicator = require("content/cells/replicators/Replicator")

local Backreplicator = setmetatable({
    name = "backreplicator",
    k3 = 394,
    title = "Backreplicator",
    description = "Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = Replicator })
Backreplicator.__index = Backreplicator

return Backreplicator
