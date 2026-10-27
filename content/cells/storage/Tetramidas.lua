local Midas = require("content/cells/storage/Midas")

local Tetramidas = setmetatable({
    name = "tetramidas",
    k3 = 425,
    title = "Tetramidas",
    description = "4-sided Midas.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Midas })
Tetramidas.__index = Tetramidas

return Tetramidas
