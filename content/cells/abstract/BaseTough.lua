local BaseCell = require("content/cells/abstract/BaseCell")

local walls = { protect = true, push = true, pull = true, grab = true, swap = true, tunnel = true, scissor = true }

local BaseTough = setmetatable({}, { __index = BaseCell })
BaseTough.__index = BaseTough

function BaseTough:guarded(guard, dx, dy)
    if dx and walls[guard] and self.shields[self:_face(dx, dy)] then return true end

    return BaseCell.guarded(self, guard)
end

return BaseTough
