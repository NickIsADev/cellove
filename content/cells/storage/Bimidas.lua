local Midas = require("content/cells/storage/Midas")

local Bimidas = setmetatable({
    name = "bimidas",
    k3 = 739,
    title = "Bimidas",
    description = "2-sided Midas.",
    outputs = { 1, 3 }
}, { __index = Midas })
Bimidas.__index = Bimidas

return Bimidas
