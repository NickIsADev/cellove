local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")

local PhysicalDirectionalTetrabackmaker = setmetatable({
    name = "physicaldirectionaltetrabackmaker",
    k3 = 1067,
    title = "Physical Directional Tetrabackmaker",
    description = "Physical Back version of Directional Tetramaker.",
    retreat = "first"
}, { __index = DirectionalTetramaker })
PhysicalDirectionalTetrabackmaker.__index = PhysicalDirectionalTetrabackmaker

return PhysicalDirectionalTetrabackmaker
