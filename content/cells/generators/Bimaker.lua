local Maker = require("content/cells/generators/Maker")

local Bimaker = setmetatable({
    name = "bimaker",
    k3 = 528,
    title = "Bimaker",
    description = "2 opposite-sided Makers.",
    outputs = { 0, 2 }
}, { __index = Maker })
Bimaker.__index = Bimaker

return Bimaker
