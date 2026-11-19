local FriendlyTurret = require("content/cells/sentries/FriendlyTurret")
local FriendlyMegaExplosiveSeeker = require("content/cells/missiles/FriendlyMegaExplosiveSeeker")

local FriendlyMegaExplosiveTurret = setmetatable({
    name = "friendlymegaexplosiveturret",
    k3 = 807,
    title = "Friendly Mega-Explosive Turret",
    description = "Explodes bigger when destroyed. Fires Friendly Mega-Explosive Seekers.",
    blast = "surrounding",
    missile = FriendlyMegaExplosiveSeeker
}, { __index = FriendlyTurret })
FriendlyMegaExplosiveTurret.__index = FriendlyMegaExplosiveTurret

return FriendlyMegaExplosiveTurret
