local Maker = require("content/cells/generators/Maker")

local DirectionalBimaker = setmetatable({
    name = "directionalbimaker",
    k3 = 532,
    title = "Directional Bimaker",
    description = "Two opposite-sided Makers that rotate the generated cell depending on direction.",
    outputs = { 0, 2 },
    aligns = true
}, { __index = Maker })
DirectionalBimaker.__index = DirectionalBimaker

return DirectionalBimaker
