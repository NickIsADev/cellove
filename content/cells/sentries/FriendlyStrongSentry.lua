local FriendlySentry = require("content/cells/sentries/FriendlySentry")
local FriendlyStrongMissile = require("content/cells/missiles/FriendlyStrongMissile")

local FriendlyStrongSentry = setmetatable({
    name = "friendlystrongsentry",
    k3 = 593,
    title = "Friendly Strong Sentry",
    description = "Takes two hits to destroy. Becomes a Friendly Sentry when hit. Fires Friendly Strong Missiles.",
    weak = FriendlySentry,
    missile = FriendlyStrongMissile
}, { __index = FriendlySentry })
FriendlyStrongSentry.__index = FriendlyStrongSentry

return FriendlyStrongSentry
