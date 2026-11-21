local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Unscissorable = setmetatable({
    name = "unscissorable",
    k3 = 936,
    title = "Unscissorable",
    description = "Cannot be cut by scissors.",
    guards = { scissor = true }
}, { __index = BaseOpposition })
Unscissorable.__index = Unscissorable

return Unscissorable
