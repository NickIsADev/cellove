local Midas = require("content/cells/storage/Midas")

local Bimidas = setmetatable({
    name = "bimidas",
    k3 = 739,
    title = "Bimidas",
    description = "Two-sided Midas.",
    outputs = { 0, 2 }
}, { __index = Midas })
Bimidas.__index = Bimidas

return Bimidas
