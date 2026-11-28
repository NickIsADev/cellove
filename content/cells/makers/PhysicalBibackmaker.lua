local Bimaker = require("content/cells/generators/Bimaker")

local PhysicalBibackmaker = setmetatable({
    name = "physicalbibackmaker",
    k3 = 1061,
    title = "Physical Bibackmaker",
    description = "Physical Back version of Bimaker.",
    retreat = "first"
}, { __index = Bimaker })
PhysicalBibackmaker.__index = PhysicalBibackmaker

return PhysicalBibackmaker
