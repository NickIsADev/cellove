local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")

local FriendlyMegaExplosiveMissile = setmetatable({
    name = "friendlymegaexplosivemissile",
    k3 = 600,
    title = "Friendly Mega-Explosive Missile",
    description = "Explodes when destroyed, destroying all eight cells around it.",
    blast = "surrounding"
}, { __index = FriendlyMissile })
FriendlyMegaExplosiveMissile.__index = FriendlyMegaExplosiveMissile

return FriendlyMegaExplosiveMissile
