local BaseHolder = require("content/cells/abstract/BaseHolder")

local Midas = setmetatable({
    name = "midas",
    k3 = 737,
    title = "Midas",
    description = "Transforms the cell it points to into the cell it holds. Is immune to transformation.",
    categories = { "midases" },
    subtick = { 2 },
    directional = true
}, { __index = BaseHolder })
Midas.__index = Midas

function Midas:transformable()
    return false
end

function Midas:update(_, direction)
    if self:held() then self:transform(direction, self:_make(direction)) end
end

return Midas
