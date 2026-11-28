local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")

local PhysicalDirectionalTetramaker = setmetatable({
    name = "physicaldirectionaltetramaker",
    k3 = 1058,
    title = "Physical Directional Tetramaker",
    description = "Physical version of Directional Tetramaker.",
    retreat = "blocked"
}, { __index = DirectionalTetramaker })
PhysicalDirectionalTetramaker.__index = PhysicalDirectionalTetramaker

return PhysicalDirectionalTetramaker
