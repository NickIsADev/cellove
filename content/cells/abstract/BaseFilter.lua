local BaseCell = require("content/cells/abstract/BaseCell")

local BaseFilter = setmetatable({
    categories = { "weights" },
    faces = {}
}, { __index = BaseCell })
BaseFilter.__index = BaseFilter

function BaseFilter:resist(force, dx, dy)
    if self.front and self:_face(dx, dy) ~= "front" then return force end

    return self:_filter(force)
end

return BaseFilter
