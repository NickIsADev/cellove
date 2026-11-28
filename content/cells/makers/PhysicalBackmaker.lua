local Maker = require("content/cells/generators/Maker")

local PhysicalBackmaker = setmetatable({
    name = "physicalbackmaker",
    k3 = 1059,
    title = "Physical Backmaker",
    description = "Physical Back version of Maker.",
    retreat = "first"
}, { __index = Maker })
PhysicalBackmaker.__index = PhysicalBackmaker

return PhysicalBackmaker
