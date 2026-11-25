local BaseCell = require("content/cells/abstract/BaseCell")

local BaseTwirler = setmetatable({
    categories = { "rotators" },
    faces = {},
    spin = 1
}, { __index = BaseCell })
BaseTwirler.__index = BaseTwirler

function BaseTwirler:_spin(cell)
    cell:rotate(self.spin, false, true)
end

function BaseTwirler:ahead(target)
    self:_spin(target)
end

return BaseTwirler
