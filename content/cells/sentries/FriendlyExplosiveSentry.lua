local FriendlySentry = require("content/cells/sentries/FriendlySentry")
local FriendlyExplosiveMissile = require("content/cells/missiles/FriendlyExplosiveMissile")

local FriendlyExplosiveSentry = setmetatable({
    name = "friendlyexplosivesentry",
    k3 = 595,
    title = "Friendly Explosive Sentry",
    description = "Explodes when destroyed. Fires Friendly Explosive Missiles.",
    blast = "neighbors",
    missile = FriendlyExplosiveMissile
}, { __index = FriendlySentry })
FriendlyExplosiveSentry.__index = FriendlyExplosiveSentry

return FriendlyExplosiveSentry
