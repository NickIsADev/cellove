local DirectionalBimaker = require("content/cells/generators/DirectionalBimaker")

local PhysicalDirectionalBimaker = setmetatable({
    name = "physicaldirectionalbimaker",
    k3 = 1056,
    title = "Physical Directional Bimaker",
    description = "Physical version of Directional Bimaker.",
    retreat = "blocked"
}, { __index = DirectionalBimaker })
PhysicalDirectionalBimaker.__index = PhysicalDirectionalBimaker

return PhysicalDirectionalBimaker
