local FriendlyTurret = require("content/cells/sentries/FriendlyTurret")
local FriendlySuperSeeker = require("content/cells/missiles/FriendlySuperSeeker")

local FriendlySuperTurret = setmetatable({
    name = "friendlysuperturret",
    k3 = 805,
    title = "Friendly Super Turret",
    description = "Cannot be destroyed by hits. Fires Friendly Super Seekers.",
    tough = true,
    missile = FriendlySuperSeeker
}, { __index = FriendlyTurret })
FriendlySuperTurret.__index = FriendlySuperTurret

return FriendlySuperTurret
