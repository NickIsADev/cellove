local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")

local FriendlyExplosiveMissile = setmetatable({
    name = "friendlyexplosivemissile",
    k3 = 599,
    title = "Friendly Explosive Missile",
    description = "Explodes when destroyed, destroying the cells next to it.",
    blast = "neighbors"
}, { __index = FriendlyMissile })
FriendlyExplosiveMissile.__index = FriendlyExplosiveMissile

return FriendlyExplosiveMissile
