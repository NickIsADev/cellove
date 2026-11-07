local Vacuum = require("content/cells/impulsors/Vacuum")

local Henavacuum = setmetatable({
    name = "henavacuum",
    k3 = 1011,
    title = "Henavacuum",
    description = "Vacuum that only pulls in front of it and to both its sides.",
    inputs = { 0, 1, 3 }
}, { __index = Vacuum })
Henavacuum.__index = Henavacuum

return Henavacuum
