local BaseCell = require("content/cells/abstract/BaseCell")

local BaseTough = setmetatable({}, { __index = BaseCell })
BaseTough.__index = BaseTough

function BaseTough:guarded(guard, dx, dy)
    if dx and (guard == "protect" or guard == "push" or guard == "pull") and self.shields[self:_face(dx, dy)] then return true end

    return BaseCell.guarded(self, guard)
end

return BaseTough
