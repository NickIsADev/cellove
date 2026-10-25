local Bidiverger = require("content/cells/divergers/Bidiverger")

local Bidisplacer = setmetatable({
    name = "bidisplacer",
    k3 = 92,
    title = "Bidisplacer",
    description = "Bidiverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = Bidiverger })
Bidisplacer.__index = Bidisplacer

return Bidisplacer
