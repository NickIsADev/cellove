local Turret = require("content/cells/sentries/Turret")
local MegaExplosiveSeeker = require("content/cells/missiles/MegaExplosiveSeeker")

local MegaExplosiveTurret = setmetatable({
    name = "megaexplosiveturret",
    k3 = 799,
    title = "Mega-Explosive Turret",
    description = "Explodes bigger when destroyed. Fires Mega-Explosive Seekers.",
    blast = "surrounding",
    missile = MegaExplosiveSeeker
}, { __index = Turret })
MegaExplosiveTurret.__index = MegaExplosiveTurret

return MegaExplosiveTurret
