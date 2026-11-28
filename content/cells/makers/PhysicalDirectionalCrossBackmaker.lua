local DirectionalCrossMaker = require("content/cells/generators/DirectionalCrossMaker")

local PhysicalDirectionalCrossBackmaker = setmetatable({
    name = "physicaldirectionalcrossbackmaker",
    k3 = 1064,
    title = "Physical Directional Cross Backmaker",
    description = "Physical Back version of Directional Cross Maker.",
    retreat = "first"
}, { __index = DirectionalCrossMaker })
PhysicalDirectionalCrossBackmaker.__index = PhysicalDirectionalCrossBackmaker

return PhysicalDirectionalCrossBackmaker
