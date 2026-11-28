local PhysicalGenerator = require("content/cells/physicalgenerators/PhysicalGenerator")

local PhysicalBackgenerator = setmetatable({
    name = "physicalbackgenerator",
    k3 = 395,
    title = "Physical Backgenerator",
    description = "If blocked from going backwards, it acts like a Generator.",
    retreat = "first"
}, { __index = PhysicalGenerator })
PhysicalBackgenerator.__index = PhysicalBackgenerator

return PhysicalBackgenerator
