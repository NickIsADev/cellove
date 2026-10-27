local Midas = require("content/cells/storage/Midas")

local DirectionalBimidas = setmetatable({
    name = "directionalbimidas",
    k3 = 743,
    title = "Directional Bimidas",
    description = "Bimidas that rotates the output depending on the transformation direction.",
    outputs = { 1, 3 },
    aligns = true
}, { __index = Midas })
DirectionalBimidas.__index = DirectionalBimidas

return DirectionalBimidas
