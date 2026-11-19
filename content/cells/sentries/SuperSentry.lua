local Sentry = require("content/cells/sentries/Sentry")
local SuperMissile = require("content/cells/missiles/SuperMissile")

local SuperSentry = setmetatable({
    name = "supersentry",
    k3 = 590,
    title = "Super Sentry",
    description = "Cannot be destroyed by hits. Fires Super Missiles.",
    tough = true,
    missile = SuperMissile
}, { __index = Sentry })
SuperSentry.__index = SuperSentry

return SuperSentry
