local Generator = require("content/cells/generators/Generator")

local Bendgenerator = setmetatable({
    name = "bendgenerator",
    k3 = 701,
    title = "Bendgenerator",
    description = "If its push is blocked, it will attempt to bend the push.",
    pushing = { bend = true }
}, { __index = Generator })
Bendgenerator.__index = Bendgenerator

return Bendgenerator
