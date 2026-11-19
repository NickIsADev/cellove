local FriendlySentry = require("content/cells/sentries/FriendlySentry")
local FriendlySuperMissile = require("content/cells/missiles/FriendlySuperMissile")

local FriendlySuperSentry = setmetatable({
    name = "friendlysupersentry",
    k3 = 594,
    title = "Friendly Super Sentry",
    description = "Cannot be destroyed by hits. Fires Friendly Super Missiles.",
    tough = true,
    missile = FriendlySuperMissile
}, { __index = FriendlySentry })
FriendlySuperSentry.__index = FriendlySuperSentry

return FriendlySuperSentry
