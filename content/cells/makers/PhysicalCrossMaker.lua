local CrossMaker = require("content/cells/generators/CrossMaker")

local PhysicalCrossMaker = setmetatable({
    name = "physicalcrossmaker",
    k3 = 1051,
    title = "Physical Cross Maker",
    description = "Physical version of Cross Maker.",
    retreat = "blocked"
}, { __index = CrossMaker })
PhysicalCrossMaker.__index = PhysicalCrossMaker

return PhysicalCrossMaker
