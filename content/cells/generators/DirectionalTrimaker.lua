local Maker = require("content/cells/generators/Maker")

local DirectionalTrimaker = setmetatable({
    name = "directionaltrimaker",
    k3 = 533,
    title = "Directional Trimaker",
    description = "3 Makers that rotate the generated cell depending on direction.",
    outputs = { 0, 1, 3 },
    aligns = true
}, { __index = Maker })
DirectionalTrimaker.__index = DirectionalTrimaker

return DirectionalTrimaker
