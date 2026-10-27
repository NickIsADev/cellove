local BaseCell = require("content/cells/abstract/BaseCell")

local BaseRotator = setmetatable({
    categories = { "rotators" },
    subtick = { 1 },
    spin = 1
}, { __index = BaseCell })
BaseRotator.__index = BaseRotator

function BaseRotator:update()
    local class = getmetatable(self)
    self:rotateNeighbors(class.random and math.random(0, 1) * 2 - 1 or class.spin)
end

return BaseRotator
