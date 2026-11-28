local SuperReplicator = require("content/cells/replicators/SuperReplicator")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSuperReplicator = setmetatable({
    name = "brokensuperreplicator",
    k3 = 1090,
    title = "Broken Super Replicator",
    description = "Super Replicator that can only be used once. It is destroyed after replicating."
}, { __index = SuperReplicator })
BrokenSuperReplicator.__index = BrokenSuperReplicator

BrokenSuperReplicator.generated = BaseBroken.generated

return BrokenSuperReplicator
