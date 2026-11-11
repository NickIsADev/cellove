local BaseCell = require("content/cells/abstract/BaseCell")

local Trash = setmetatable({
    name = "trash",
    k3 = 12,
    title = "Trash",
    description = "Deletes any cell that moves into it.",
    categories = { "trashes" },
    fixed = true
}, { __index = BaseCell })
Trash.__index = Trash

function Trash:eats()
    return true
end

function Trash:generatable()
    return not self.phantom
end

return Trash
