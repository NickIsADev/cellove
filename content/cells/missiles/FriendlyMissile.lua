local Missile = require("content/cells/missiles/Missile")

local FriendlyMissile = setmetatable({
    name = "friendlymissile",
    k3 = 456,
    title = "Friendly Missile",
    description = "Missile on the players' side: hostile Sentries and Seekers target it, friendly ones ignore it.",
    team = "friendly"
}, { __index = Missile })
FriendlyMissile.__index = FriendlyMissile

return FriendlyMissile
