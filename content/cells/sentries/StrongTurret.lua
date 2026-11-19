local Turret = require("content/cells/sentries/Turret")
local StrongSeeker = require("content/cells/missiles/StrongSeeker")

local StrongTurret = setmetatable({
    name = "strongturret",
    k3 = 796,
    title = "Strong Turret",
    description = "Takes two hits to destroy. Becomes a Turret when hit. Fires Strong Seekers.",
    weak = Turret,
    missile = StrongSeeker
}, { __index = Turret })
StrongTurret.__index = StrongTurret

return StrongTurret
