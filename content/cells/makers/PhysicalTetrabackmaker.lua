local Tetramaker = require("content/cells/generators/Tetramaker")

local PhysicalTetrabackmaker = setmetatable({
    name = "physicaltetrabackmaker",
    k3 = 1063,
    title = "Physical Tetrabackmaker",
    description = "Physical Back version of Tetramaker.",
    retreat = "first"
}, { __index = Tetramaker })
PhysicalTetrabackmaker.__index = PhysicalTetrabackmaker

return PhysicalTetrabackmaker
