local Advancer = require("content/cells/movers/Advancer")

local InclusiveAdvancer = setmetatable({
    name = "inclusiveadvancer",
    k3 = 311,
    title = "Inclusive Advancer",
    description = "An Advancer that only moves if it can both push and pull.",
    options = { strict = true }
}, { __index = Advancer })
InclusiveAdvancer.__index = InclusiveAdvancer

return InclusiveAdvancer
