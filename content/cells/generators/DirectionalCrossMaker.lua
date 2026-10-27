local Maker = require("content/cells/generators/Maker")

local DirectionalCrossMaker = setmetatable({
    name = "directionalcrossmaker",
    k3 = 531,
    title = "Directional Cross Maker",
    description = "2 Makers that rotate the generated cell depending on direction.",
    outputs = { 0, 3 },
    aligns = true
}, { __index = Maker })
DirectionalCrossMaker.__index = DirectionalCrossMaker

return DirectionalCrossMaker
