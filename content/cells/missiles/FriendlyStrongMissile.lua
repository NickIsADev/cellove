local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")

local FriendlyStrongMissile = setmetatable({
    name = "friendlystrongmissile",
    k3 = 597,
    title = "Friendly Strong Missile",
    description = "Takes two hits to destroy. Becomes a Friendly Missile when hit.",
    weak = FriendlyMissile
}, { __index = FriendlyMissile })
FriendlyStrongMissile.__index = FriendlyStrongMissile

return FriendlyStrongMissile
