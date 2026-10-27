local Maker = require("content/cells/generators/Maker")

local DirectionalBimaker = setmetatable({
    name = "directionalbimaker",
    k3 = 532,
    title = "Directional Bimaker",
    description = "2 opposite-sided Makers that rotate the generated cell depending on direction.",
    outputs = { 1, 3 },
    aligns = true
}, { __index = Maker })
DirectionalBimaker.__index = DirectionalBimaker

return DirectionalBimaker
