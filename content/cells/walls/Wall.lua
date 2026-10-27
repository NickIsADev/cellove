local BaseCell = require("content/cells/abstract/BaseCell")

local Wall = setmetatable({
    name = "wall",
    k3 = 1,
    title = "Wall",
    description = "Cannot be pushed, rotated, or destroyed.",
    categories = { "walls" }
}, { __index = BaseCell })
Wall.__index = Wall

function Wall:pushable()
    return false
end

function Wall:transformable()
    return false
end

function Wall:rotate()
end

return Wall
