local Enemy = require("content/cells/destroyers/Enemy")

local Ally = setmetatable({
    name = "ally",
    k3 = 768,
    title = "Ally",
    description = "Explodes when pushed into, taking the cell that pushed it along. A puzzle is failed if fewer Allies remain than there were at the start.",
    categories = { "allies" },
    hostile = false,
    friendly = true
}, { __index = Enemy })
Ally.__index = Ally

return Ally
