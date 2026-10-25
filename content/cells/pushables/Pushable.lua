local BaseCell = require("content/cells/abstract/BaseCell")

local Pushable = setmetatable({
    name = "pushable",
    k3 = 4,
    title = "Pushable",
    description = "Does nothing on its own, but can be pushed in any direction.",
    categories = { "pushables" }
}, { __index = BaseCell })
Pushable.__index = Pushable

return Pushable
