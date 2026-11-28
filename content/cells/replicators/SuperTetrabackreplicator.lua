local SuperTetrareplicator = require("content/cells/replicators/SuperTetrareplicator")

local SuperTetrabackreplicator = setmetatable({
    name = "supertetrabackreplicator",
    k3 = 889,
    title = "Super Tetrabackreplicator",
    description = "Super Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = SuperTetrareplicator })
SuperTetrabackreplicator.__index = SuperTetrabackreplicator

return SuperTetrabackreplicator
