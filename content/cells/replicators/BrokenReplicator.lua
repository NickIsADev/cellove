local Replicator = require("content/cells/replicators/Replicator")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenReplicator = setmetatable({
    name = "brokenreplicator",
    k3 = 302,
    title = "Broken Replicator",
    description = "Replicator that can only be used once. It is destroyed after replicating."
}, { __index = Replicator })
BrokenReplicator.__index = BrokenReplicator

BrokenReplicator.generated = BaseBroken.generated

return BrokenReplicator
