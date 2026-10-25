local Wall = require("content/cells/walls/Wall")

local Ghost = setmetatable({
    name = "ghost",
    k3 = 41,
    title = "Ghost",
    description = "A wall that cannot be generated."
}, { __index = Wall })
Ghost.__index = Ghost

function Ghost:generatable()
    return false
end

return Ghost
