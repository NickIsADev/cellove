local BaseEffector = require("content/cells/abstract/BaseEffector")

local BaseEffectGiver = setmetatable({
    subtick = { "effectGiver" },
    value = true
}, { __index = BaseEffector })
BaseEffectGiver.__index = BaseEffectGiver

function BaseEffectGiver:_value()
    return self.value
end

function BaseEffectGiver:_affect(cell)
    for _, effect in ipairs(self.gives) do
        effect:apply(cell, self:_value(), self.sides.diagonal)
    end
end

return BaseEffectGiver
