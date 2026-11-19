local FriendlySentry = require("content/cells/sentries/FriendlySentry")
local FriendlyMegaExplosiveMissile = require("content/cells/missiles/FriendlyMegaExplosiveMissile")

local FriendlyMegaExplosiveSentry = setmetatable({
    name = "friendlymegaexplosivesentry",
    k3 = 596,
    title = "Friendly Mega-Explosive Sentry",
    description = "Explodes bigger when destroyed. Fires Friendly Mega-Explosive Missiles.",
    blast = "surrounding",
    missile = FriendlyMegaExplosiveMissile
}, { __index = FriendlySentry })
FriendlyMegaExplosiveSentry.__index = FriendlyMegaExplosiveSentry

return FriendlyMegaExplosiveSentry
