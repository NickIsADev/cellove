local Bimaker = require("content/cells/generators/Bimaker")

local PhysicalBimaker = setmetatable({
    name = "physicalbimaker",
    k3 = 1052,
    title = "Physical Bimaker",
    description = "Physical version of Bimaker.",
    retreat = "blocked"
}, { __index = Bimaker })
PhysicalBimaker.__index = PhysicalBimaker

return PhysicalBimaker
