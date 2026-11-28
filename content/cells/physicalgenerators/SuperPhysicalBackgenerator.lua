local SuperPhysicalGenerator = require("content/cells/physicalgenerators/SuperPhysicalGenerator")

local SuperPhysicalBackgenerator = setmetatable({
    name = "superphysicalbackgenerator",
    k3 = 674,
    title = "Super Physical Backgenerator",
    description = "If blocked from going backwards, it acts like a Generator.",
    retreat = "first"
}, { __index = SuperPhysicalGenerator })
SuperPhysicalBackgenerator.__index = SuperPhysicalBackgenerator

return SuperPhysicalBackgenerator
