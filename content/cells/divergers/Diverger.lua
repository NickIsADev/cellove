local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local Diverger = setmetatable({
    name = "diverger",
    k3 = 16,
    title = "Diverger",
    description = "Turns cells entering from the side out through its arrow.",
    routes = { [0] = -1, [1] = 1 }
}, { __index = BaseDiverger })
Diverger.__index = Diverger

return Diverger
