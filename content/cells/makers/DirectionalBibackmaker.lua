local DirectionalBimaker = require("content/cells/generators/DirectionalBimaker")

local DirectionalBibackmaker = setmetatable({
    name = "directionalbibackmaker",
    k3 = 1074,
    title = "Directional Bibackmaker",
    description = "Back version of Directional Bimaker.",
    retreat = "always"
}, { __index = DirectionalBimaker })
DirectionalBibackmaker.__index = DirectionalBibackmaker

return DirectionalBibackmaker
