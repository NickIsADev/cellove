local SuperBireplicator = require("content/cells/replicators/SuperBireplicator")

local SuperBibackreplicator = setmetatable({
    name = "superbibackreplicator",
    k3 = 883,
    title = "Super Bibackreplicator",
    description = "Super Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = SuperBireplicator })
SuperBibackreplicator.__index = SuperBibackreplicator

return SuperBibackreplicator
