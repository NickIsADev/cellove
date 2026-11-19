local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")

local FriendlySuperMissile = setmetatable({
    name = "friendlysupermissile",
    k3 = 598,
    title = "Friendly Super Missile",
    description = "Cannot be destroyed by hits.",
    tough = true
}, { __index = FriendlyMissile })
FriendlySuperMissile.__index = FriendlySuperMissile

return FriendlySuperMissile
