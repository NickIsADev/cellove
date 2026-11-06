local BaseCell = require("content/cells/abstract/BaseCell")

local BaseRotator = setmetatable({
    categories = { "rotators" },
    faces = {},
    subtick = { 10 },
    sweep = { x = 1, y = -1 },
    spin = 1
}, { __index = BaseCell })
BaseRotator.__index = BaseRotator

function BaseRotator:update()
    self:rotateNeighbors(self.random and math.random(0, 1) * 2 - 1 or self.spin)
end

return BaseRotator
