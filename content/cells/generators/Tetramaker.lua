local Maker = require("content/cells/generators/Maker")

local Tetramaker = setmetatable({
    name = "tetramaker",
    k3 = 530,
    title = "Tetramaker",
    description = "4 Makers.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Maker })
Tetramaker.__index = Tetramaker

return Tetramaker
