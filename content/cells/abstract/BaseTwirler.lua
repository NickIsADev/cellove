local BaseCell = require("content/cells/abstract/BaseCell")

local BaseTwirler = setmetatable({
    categories = { "rotators" },
    spin = 1
}, { __index = BaseCell })
BaseTwirler.__index = BaseTwirler

function BaseTwirler:_spin(cell)
    cell:rotate(self.spin)
end

function BaseTwirler:chained(action, dx, dy)
    if action ~= "push" then return end

    local cell = self.grid:get(self.x + dx, self.y + dy)
    if cell then self:_spin(cell) end
end

return BaseTwirler
