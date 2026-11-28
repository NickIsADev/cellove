local DirectionalTrimaker = require("content/cells/generators/DirectionalTrimaker")

local DirectionalTribackmaker = setmetatable({
    name = "directionaltribackmaker",
    k3 = 1075,
    title = "Directional Tribackmaker",
    description = "Back version of Directional Trimaker.",
    retreat = "always"
}, { __index = DirectionalTrimaker })
DirectionalTribackmaker.__index = DirectionalTribackmaker

return DirectionalTribackmaker
