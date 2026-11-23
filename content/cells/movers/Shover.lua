local Heaver = require("content/cells/movers/Heaver")

local Shover = setmetatable({
    name = "shover",
    k3 = 400,
    title = "Shover",
    description = "A Heaver whose grabbed cells push instead of nudge.",
    strong = true
}, { __index = Heaver })
Shover.__index = Shover

return Shover
