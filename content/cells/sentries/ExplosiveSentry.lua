local Sentry = require("content/cells/sentries/Sentry")
local ExplosiveMissile = require("content/cells/missiles/ExplosiveMissile")

local ExplosiveSentry = setmetatable({
    name = "explosivesentry",
    k3 = 591,
    title = "Explosive Sentry",
    description = "Explodes when destroyed. Fires Explosive Missiles.",
    blast = "neighbors",
    missile = ExplosiveMissile
}, { __index = Sentry })
ExplosiveSentry.__index = ExplosiveSentry

return ExplosiveSentry
