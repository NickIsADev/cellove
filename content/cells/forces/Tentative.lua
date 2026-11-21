local Resistance = require("content/cells/forces/Resistance")

local Tentative = setmetatable({
    name = "tentative",
    k3 = 143,
    title = "Tentative",
    description = "Blocks any force that is not equal to its rotation plus 1 units."
}, { __index = Resistance })
Tentative.__index = Tentative

function Tentative:_limit()
    return self.rotation + 1
end

return Tentative
