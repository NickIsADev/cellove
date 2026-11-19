local Sentry = require("content/cells/sentries/Sentry")
local Seeker = require("content/cells/missiles/Seeker")

local Turret = setmetatable({
    name = "turret",
    k3 = 320,
    title = "Turret",
    description = "Sentry that fires Seekers.",
    missile = Seeker
}, { __index = Sentry })
Turret.__index = Turret

return Turret
