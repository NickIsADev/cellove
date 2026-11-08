local Impulsor = require("content/cells/impulsors/Impulsor")

local Hemiimpulsor = setmetatable({
    name = "hemiimpulsor",
    k3 = 415,
    title = "Hemiimpulsor",
    description = "Impulsor that only pulls in front of it and to its left.",
    inputs = { 0, 3 }
}, { __index = Impulsor })
Hemiimpulsor.__index = Hemiimpulsor

return Hemiimpulsor
