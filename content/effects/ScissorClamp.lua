local BaseEffect = require("content/effects/abstract/BaseEffect")

local ScissorClamp = setmetatable({
    name = "scissorclamp",
    guards = { scissor = true }
}, { __index = BaseEffect })
ScissorClamp.__index = ScissorClamp

return ScissorClamp
