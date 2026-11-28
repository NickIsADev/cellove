local PhysicalGenerator = require("content/cells/physicalgenerators/PhysicalGenerator")

local Backgenerator = setmetatable({
    name = "backgenerator",
    k3 = 393,
    title = "Backgenerator",
    description = "Always moves backwards to generate, as if it were blocked.",
    retreat = "always"
}, { __index = PhysicalGenerator })
Backgenerator.__index = Backgenerator

return Backgenerator
