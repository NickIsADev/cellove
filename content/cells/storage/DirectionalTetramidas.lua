local Midas = require("content/cells/storage/Midas")

local DirectionalTetramidas = setmetatable({
    name = "directionaltetramidas",
    k3 = 426,
    title = "Directional Tetramidas",
    description = "Tetramidas that rotates the output depending on the transformation direction.",
    outputs = { 0, 1, 2, 3 },
    aligns = true
}, { __index = Midas })
DirectionalTetramidas.__index = DirectionalTetramidas

return DirectionalTetramidas
