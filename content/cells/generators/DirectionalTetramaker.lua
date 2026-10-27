local Maker = require("content/cells/generators/Maker")

local DirectionalTetramaker = setmetatable({
    name = "directionaltetramaker",
    k3 = 534,
    title = "Directional Tetramaker",
    description = "4 Makers that rotate the generated cell depending on direction.",
    outputs = { 0, 1, 2, 3 },
    aligns = true
}, { __index = Maker })
DirectionalTetramaker.__index = DirectionalTetramaker

return DirectionalTetramaker
