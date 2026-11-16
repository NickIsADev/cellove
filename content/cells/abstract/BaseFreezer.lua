local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Frozen = require("content/effects/Frozen")

local BaseFreezer = setmetatable({
    subtick = { "freezer" },
    gives = { Frozen },
    freezes = true
}, { __index = BaseEffectGiver })
BaseFreezer.__index = BaseFreezer

return BaseFreezer
