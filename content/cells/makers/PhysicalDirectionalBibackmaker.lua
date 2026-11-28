local DirectionalBimaker = require("content/cells/generators/DirectionalBimaker")

local PhysicalDirectionalBibackmaker = setmetatable({
    name = "physicaldirectionalbibackmaker",
    k3 = 1065,
    title = "Physical Directional Bibackmaker",
    description = "Physical Back version of Directional Bimaker.",
    retreat = "first"
}, { __index = DirectionalBimaker })
PhysicalDirectionalBibackmaker.__index = PhysicalDirectionalBibackmaker

return PhysicalDirectionalBibackmaker
