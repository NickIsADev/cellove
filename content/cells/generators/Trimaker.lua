local Maker = require("content/cells/generators/Maker")

local Trimaker = setmetatable({
    name = "trimaker",
    k3 = 529,
    title = "Trimaker",
    description = "3 Makers.",
    outputs = { 0, 1, 3 }
}, { __index = Maker })
Trimaker.__index = Trimaker

return Trimaker
