local Midas = require("content/cells/storage/Midas")

local Trimidas = setmetatable({
    name = "trimidas",
    k3 = 740,
    title = "Trimidas",
    description = "3-sided Midas.",
    outputs = { 0, 1, 3 }
}, { __index = Midas })
Trimidas.__index = Trimidas

return Trimidas
