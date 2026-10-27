local BaseHolder = require("content/cells/abstract/BaseHolder")

local InputStorage = setmetatable({
    name = "inputstorage",
    k3 = 918,
    title = "Input Storage",
    description = "Can be clicked to turn it into the cell inside of it. Does not absorb cells like a normal Storage."
}, { __index = BaseHolder })
InputStorage.__index = InputStorage

function InputStorage:eats()
    return false
end

function InputStorage:click(button)
    if button ~= 1 then return false end

    if self:held() then
        self:_become()
    else
        self:kill()
    end
    return true
end

return InputStorage
