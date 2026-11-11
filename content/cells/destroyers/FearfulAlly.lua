local FearfulEnemy = require("content/cells/destroyers/FearfulEnemy")

local FearfulAlly = setmetatable({
    name = "fearfulally",
    k3 = 1173,
    title = "Fearful Ally",
    description = "Runs away from adjacent cells every tick, pushing whatever is in its way. Explodes when pushed into, taking the cell that pushed it along. A puzzle is failed if fewer Allies remain than there were at the start.",
    hostile = false,
    friendly = true,
    categories = { "allies" }
}, { __index = FearfulEnemy })
FearfulAlly.__index = FearfulAlly

return FearfulAlly
