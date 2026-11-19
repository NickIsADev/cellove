local Sentry = require("content/cells/sentries/Sentry")
local MegaExplosiveMissile = require("content/cells/missiles/MegaExplosiveMissile")

local MegaExplosiveSentry = setmetatable({
    name = "megaexplosivesentry",
    k3 = 592,
    title = "Mega-Explosive Sentry",
    description = "Explodes bigger when destroyed. Fires Mega-Explosive Missiles.",
    blast = "surrounding",
    missile = MegaExplosiveMissile
}, { __index = Sentry })
MegaExplosiveSentry.__index = MegaExplosiveSentry

return MegaExplosiveSentry
