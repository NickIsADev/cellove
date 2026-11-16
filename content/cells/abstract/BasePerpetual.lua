local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Spin = require("content/effects/Spin")

local BasePerpetual = setmetatable({
    gives = { Spin },
    inclusive = false
}, { __index = BaseEffectGiver })
BasePerpetual.__index = BasePerpetual

return BasePerpetual
