local DirectionalCrossMaker = require("content/cells/generators/DirectionalCrossMaker")

local PhysicalDirectionalCrossMaker = setmetatable({
    name = "physicaldirectionalcrossmaker",
    k3 = 1055,
    title = "Physical Directional Cross Maker",
    description = "Physical version of Directional Cross Maker.",
    retreat = "blocked"
}, { __index = DirectionalCrossMaker })
PhysicalDirectionalCrossMaker.__index = PhysicalDirectionalCrossMaker

return PhysicalDirectionalCrossMaker
