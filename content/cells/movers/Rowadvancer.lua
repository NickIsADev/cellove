local Advancer = require("content/cells/movers/Advancer")

local Rowadvancer = setmetatable({
    name = "rowadvancer",
    k3 = 720,
    title = "Rowadvancer",
    description = "Advances a whole row, without stopping at air.",
    options = { row = true }
}, { __index = Advancer })
Rowadvancer.__index = Rowadvancer

return Rowadvancer
