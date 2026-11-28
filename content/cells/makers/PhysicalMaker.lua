local Maker = require("content/cells/generators/Maker")

local PhysicalMaker = setmetatable({
    name = "physicalmaker",
    k3 = 1050,
    title = "Physical Maker",
    description = "Physical version of Maker.",
    retreat = "blocked"
}, { __index = Maker })
PhysicalMaker.__index = PhysicalMaker

return PhysicalMaker
