local BaseCell = require("content/cells/abstract/BaseCell")

local BaseTwirler = setmetatable({
    categories = { "rotators" },
    faces = {},
    spin = 1
}, { __index = BaseCell })
BaseTwirler.__index = BaseTwirler

function BaseTwirler:_spin(cell, dx, dy)
    cell:rotate(self.spin, {
        quiet = true,
        dx = dx,
        dy = dy
    })
end

function BaseTwirler:ahead(target, dx, dy)
    self:_spin(target, dx, dy)
end

return BaseTwirler
