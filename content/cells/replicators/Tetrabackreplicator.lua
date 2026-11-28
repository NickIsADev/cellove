local Tetrareplicator = require("content/cells/replicators/Tetrareplicator")

local Tetrabackreplicator = setmetatable({
    name = "tetrabackreplicator",
    k3 = 877,
    title = "Tetrabackreplicator",
    description = "Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = Tetrareplicator })
Tetrabackreplicator.__index = Tetrabackreplicator

return Tetrabackreplicator
