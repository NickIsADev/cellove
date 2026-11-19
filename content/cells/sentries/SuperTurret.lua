local Turret = require("content/cells/sentries/Turret")
local SuperSeeker = require("content/cells/missiles/SuperSeeker")

local SuperTurret = setmetatable({
    name = "superturret",
    k3 = 797,
    title = "Super Turret",
    description = "Cannot be destroyed by hits. Fires Super Seekers.",
    tough = true,
    missile = SuperSeeker
}, { __index = Turret })
SuperTurret.__index = SuperTurret

return SuperTurret
