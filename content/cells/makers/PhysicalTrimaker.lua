local Trimaker = require("content/cells/generators/Trimaker")

local PhysicalTrimaker = setmetatable({
    name = "physicaltrimaker",
    k3 = 1053,
    title = "Physical Trimaker",
    description = "Physical version of Trimaker.",
    retreat = "blocked"
}, { __index = Trimaker })
PhysicalTrimaker.__index = PhysicalTrimaker

return PhysicalTrimaker
