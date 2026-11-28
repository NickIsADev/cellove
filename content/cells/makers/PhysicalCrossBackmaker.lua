local CrossMaker = require("content/cells/generators/CrossMaker")

local PhysicalCrossBackmaker = setmetatable({
    name = "physicalcrossbackmaker",
    k3 = 1060,
    title = "Physical Cross Backmaker",
    description = "Physical Back version of Cross Maker.",
    retreat = "first"
}, { __index = CrossMaker })
PhysicalCrossBackmaker.__index = PhysicalCrossBackmaker

return PhysicalCrossBackmaker
