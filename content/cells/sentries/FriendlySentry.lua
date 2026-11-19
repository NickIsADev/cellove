local Sentry = require("content/cells/sentries/Sentry")
local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")

local FriendlySentry = setmetatable({
    name = "friendlysentry",
    k3 = 453,
    title = "Friendly Sentry",
    description = "Sentry that targets hostile cells and fires Friendly Missiles.",
    team = "friendly",
    missile = FriendlyMissile
}, { __index = Sentry })
FriendlySentry.__index = FriendlySentry

return FriendlySentry
