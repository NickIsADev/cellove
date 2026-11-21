local BaseCell = require("content/cells/abstract/BaseCell")

local BaseOpposition = setmetatable({
    categories = { "oppositions" },
    faces = {}
}, { __index = BaseCell })
BaseOpposition.__index = BaseOpposition

function BaseOpposition:pushable(dx, dy, _, action)
    local sides = self.moves and self.moves[action or "push"]
    return not self.fixed and (not sides or sides[self:_face(dx, dy)] == true)
end

return BaseOpposition
