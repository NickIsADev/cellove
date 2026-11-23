local Mover = require("content/cells/movers/Mover")

local Rowmover = setmetatable({
    name = "rowmover",
    k3 = 718,
    title = "Rowmover",
    description = "Moves a whole row, without stopping at air.",
    options = { row = true }
}, { __index = Mover })
Rowmover.__index = Rowmover

return Rowmover
