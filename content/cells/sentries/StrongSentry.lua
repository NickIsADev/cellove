local Sentry = require("content/cells/sentries/Sentry")
local StrongMissile = require("content/cells/missiles/StrongMissile")

local StrongSentry = setmetatable({
    name = "strongsentry",
    k3 = 589,
    title = "Strong Sentry",
    description = "Takes two hits to destroy. Becomes a Sentry when hit. Fires Strong Missiles.",
    weak = Sentry,
    missile = StrongMissile
}, { __index = Sentry })
StrongSentry.__index = StrongSentry

return StrongSentry
