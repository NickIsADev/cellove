local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Protected = require("content/effects/Protected")

local Minishield = setmetatable({
    name = "minishield",
    k3 = 308,
    title = "Minishield",
    description = "Prevents adjacent cells from being destroyed, infected or transformed.",
    gives = { Protected }
}, { __index = BaseEffectGiver })
Minishield.__index = Minishield

return Minishield
