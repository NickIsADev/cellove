local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local SuperBireplicator = setmetatable({
    name = "superbireplicator",
    k3 = 514,
    title = "Super Bireplicator",
    description = "Two opposite-sided Super Replicators.",
    outputs = { 0, 2 }
}, { __index = SuperReplicator })
SuperBireplicator.__index = SuperBireplicator

return SuperBireplicator
