local Anchor = require("content/cells/rotators/Anchor")

local Pin = setmetatable({
    name = "pin",
    k3 = 462,
    title = "Pin",
    description = "Swings everything attached to it around itself without turning the cells.",
    turns = false
}, { __index = Anchor })
Pin.__index = Pin

return Pin
