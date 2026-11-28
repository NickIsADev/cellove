local SuperPhysicalGenerator = require("content/cells/physicalgenerators/SuperPhysicalGenerator")

local SuperBackgenerator = setmetatable({
    name = "superbackgenerator",
    k3 = 675,
    title = "Super Backgenerator",
    description = "Always moves backwards to generate, as if it were blocked.",
    retreat = "always"
}, { __index = SuperPhysicalGenerator })
SuperBackgenerator.__index = SuperBackgenerator

return SuperBackgenerator
