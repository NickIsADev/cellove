local BaseBarrier = require("content/cells/abstract/BaseBarrier")

local BaseInput = setmetatable({
    name = "input"
}, { __index = BaseBarrier })
BaseInput.__index = BaseInput

function BaseInput:click(button)
    if button ~= 1 then return false end

    self:alternate()
    return true
end

return BaseInput
