local FriendlyTurret = require("content/cells/sentries/FriendlyTurret")
local FriendlyExplosiveSeeker = require("content/cells/missiles/FriendlyExplosiveSeeker")

local FriendlyExplosiveTurret = setmetatable({
    name = "friendlyexplosiveturret",
    k3 = 806,
    title = "Friendly Explosive Turret",
    description = "Explodes when destroyed. Fires Friendly Explosive Seekers.",
    blast = "neighbors",
    missile = FriendlyExplosiveSeeker
}, { __index = FriendlyTurret })
FriendlyExplosiveTurret.__index = FriendlyExplosiveTurret

return FriendlyExplosiveTurret
