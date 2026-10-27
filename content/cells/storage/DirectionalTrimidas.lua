local Midas = require("content/cells/storage/Midas")

local DirectionalTrimidas = setmetatable({
    name = "directionaltrimidas",
    k3 = 744,
    title = "Directional Trimidas",
    description = "Trimidas that rotates the output depending on the transformation direction.",
    outputs = { 0, 1, 3 },
    aligns = true
}, { __index = Midas })
DirectionalTrimidas.__index = DirectionalTrimidas

return DirectionalTrimidas
