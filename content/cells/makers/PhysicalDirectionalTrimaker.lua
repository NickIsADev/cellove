local DirectionalTrimaker = require("content/cells/generators/DirectionalTrimaker")

local PhysicalDirectionalTrimaker = setmetatable({
    name = "physicaldirectionaltrimaker",
    k3 = 1057,
    title = "Physical Directional Trimaker",
    description = "Physical version of Directional Trimaker.",
    retreat = "blocked"
}, { __index = DirectionalTrimaker })
PhysicalDirectionalTrimaker.__index = PhysicalDirectionalTrimaker

return PhysicalDirectionalTrimaker
