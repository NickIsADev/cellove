local BaseCell = require("content/cells/abstract/BaseCell")

local Arrow = setmetatable({
    name = "arrow",
    title = "Arrow",
    description = "Pushable that cannot be rotated by other cells.",
    categories = { "pushables" },
    faces = { 0 }
}, { __index = BaseCell })
Arrow.__index = Arrow

function Arrow:rotatable()
    return false
end

return Arrow
