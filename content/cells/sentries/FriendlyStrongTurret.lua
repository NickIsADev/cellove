local FriendlyTurret = require("content/cells/sentries/FriendlyTurret")
local FriendlyStrongSeeker = require("content/cells/missiles/FriendlyStrongSeeker")

local FriendlyStrongTurret = setmetatable({
    name = "friendlystrongturret",
    k3 = 804,
    title = "Friendly Strong Turret",
    description = "Takes two hits to destroy. Becomes a Friendly Turret when hit. Fires Friendly Strong Seekers.",
    weak = FriendlyTurret,
    missile = FriendlyStrongSeeker
}, { __index = FriendlyTurret })
FriendlyStrongTurret.__index = FriendlyStrongTurret

return FriendlyStrongTurret
