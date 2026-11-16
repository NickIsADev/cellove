local BaseEffect = require("content/effects/abstract/BaseEffect")

local TunnelClamp = setmetatable({
    name = "tunnelclamp",
    guards = { tunnel = true }
}, { __index = BaseEffect })
TunnelClamp.__index = TunnelClamp

return TunnelClamp
