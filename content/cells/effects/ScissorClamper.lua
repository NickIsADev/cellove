local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local ScissorClamp = require("content/effects/ScissorClamp")

local ScissorClamper = setmetatable({
    name = "scissorclamper",
    k3 = 253,
    title = "Scissor Clamper",
    description = "Prevents adjacent cells from being scissored.",
    gives = { ScissorClamp }
}, { __index = BaseEffectGiver })
ScissorClamper.__index = ScissorClamper

return ScissorClamper
