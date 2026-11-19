local FriendlySentry = require("content/cells/sentries/FriendlySentry")
local FriendlySeeker = require("content/cells/missiles/FriendlySeeker")

local FriendlyTurret = setmetatable({
    name = "friendlyturret",
    k3 = 455,
    title = "Friendly Turret",
    description = "Turret that targets hostile cells and fires Friendly Seekers.",
    missile = FriendlySeeker
}, { __index = FriendlySentry })
FriendlyTurret.__index = FriendlyTurret

return FriendlyTurret
