local Midas = require("content/cells/storage/Midas")

local CrossMidas = setmetatable({
    name = "crossmidas",
    k3 = 738,
    title = "Cross Midas",
    description = "2-sided Midas.",
    outputs = { 0, 3 }
}, { __index = Midas })
CrossMidas.__index = CrossMidas

return CrossMidas
