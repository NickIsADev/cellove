local DirectionalTrimaker = require("content/cells/generators/DirectionalTrimaker")

local PhysicalDirectionalTribackmaker = setmetatable({
    name = "physicaldirectionaltribackmaker",
    k3 = 1066,
    title = "Physical Directional Tribackmaker",
    description = "Physical Back version of Directional Trimaker.",
    retreat = "first"
}, { __index = DirectionalTrimaker })
PhysicalDirectionalTribackmaker.__index = PhysicalDirectionalTribackmaker

return PhysicalDirectionalTribackmaker
