local Diverger = require("content/cells/divergers/Diverger")

local Displacer = setmetatable({
    name = "displacer",
    k3 = 91,
    title = "Displacer",
    description = "Diverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = Diverger })
Displacer.__index = Displacer

return Displacer
