local BaseCell = require("content/cells/abstract/BaseCell")

local BaseAcid = setmetatable({
    categories = { "acids" },
    acid = true
}, { __index = BaseCell })
BaseAcid.__index = BaseAcid

function BaseAcid:rams(cell, dx, dy)
    return not cell.acid and cell:breakable() and not (cell:guarded("protect", dx, dy) or self:guarded("protect", -dx, -dy))
end

function BaseAcid:ram(cell)
    local damage = math.min(self:health(), cell:health())

    cell:hit(damage)
    return self:health() > damage
end

return BaseAcid
