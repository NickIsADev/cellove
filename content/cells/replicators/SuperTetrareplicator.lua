local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local SuperTetrareplicator = setmetatable({
    name = "supertetrareplicator",
    k3 = 516,
    title = "Super Tetrareplicator",
    description = "Four Super Replicators.",
    outputs = { 0, 1, 2, 3 }
}, { __index = SuperReplicator })
SuperTetrareplicator.__index = SuperTetrareplicator

return SuperTetrareplicator
