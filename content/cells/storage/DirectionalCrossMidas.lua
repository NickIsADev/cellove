local Midas = require("content/cells/storage/Midas")

local DirectionalCrossMidas = setmetatable({
    name = "directionalcrossmidas",
    k3 = 742,
    title = "Directional Cross Midas",
    description = "Cross Midas that rotates the output depending on the transformation direction.",
    outputs = { 0, 3 },
    aligns = true
}, { __index = Midas })
DirectionalCrossMidas.__index = DirectionalCrossMidas

return DirectionalCrossMidas
