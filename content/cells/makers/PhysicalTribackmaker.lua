local Trimaker = require("content/cells/generators/Trimaker")

local PhysicalTribackmaker = setmetatable({
    name = "physicaltribackmaker",
    k3 = 1062,
    title = "Physical Tribackmaker",
    description = "Physical Back version of Trimaker.",
    retreat = "first"
}, { __index = Trimaker })
PhysicalTribackmaker.__index = PhysicalTribackmaker

return PhysicalTribackmaker
