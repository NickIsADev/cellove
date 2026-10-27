local MemoryGenerator = require("content/cells/generators/MemoryGenerator")

local MemoryReplicator = setmetatable({
    name = "memoryreplicator",
    k3 = 341,
    title = "Memory Replicator",
    description = "Replicator equivalent of Memory Generator.",
    source = 0
}, { __index = MemoryGenerator })
MemoryReplicator.__index = MemoryReplicator

return MemoryReplicator
