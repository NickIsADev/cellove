local Tetramaker = require("content/cells/generators/Tetramaker")

local PhysicalTetramaker = setmetatable({
    name = "physicaltetramaker",
    k3 = 1054,
    title = "Physical Tetramaker",
    description = "Physical version of Tetramaker.",
    retreat = "blocked"
}, { __index = Tetramaker })
PhysicalTetramaker.__index = PhysicalTetramaker

return PhysicalTetramaker
