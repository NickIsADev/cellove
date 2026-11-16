local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local TunnelClamp = require("content/effects/TunnelClamp")

local TunnelClamper = setmetatable({
    name = "tunnelclamper",
    k3 = 935,
    title = "Tunnel Clamper",
    description = "Prevents adjacent cells from being tunneled through.",
    gives = { TunnelClamp }
}, { __index = BaseEffectGiver })
TunnelClamper.__index = TunnelClamper

return TunnelClamper
