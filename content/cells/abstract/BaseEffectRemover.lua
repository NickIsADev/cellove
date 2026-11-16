local BaseEffector = require("content/cells/abstract/BaseEffector")

local BaseEffectRemover = setmetatable({
    subtick = { "effectRemover" }
}, { __index = BaseEffector })
BaseEffectRemover.__index = BaseEffectRemover

function BaseEffectRemover:_affect(cell)
    for _, effect in ipairs(self.removes) do
        effect:remove(cell)
    end
end

return BaseEffectRemover
