local BaseHolder = require("content/cells/abstract/BaseHolder")

local Collider = setmetatable({
    name = "collider",
    k3 = 362,
    title = "Collider",
    description = "Like a Storage cell, but once it holds a cell, it acts like a Nudger, then once it hits a wall, it turns into the cell inside it.",
    categories = { "othermovers", "storage" },
    subtick = { "nudger" },
    drive = {
        push = true,
        pull = true,
        grab = true
    },
    directional = true
}, { __index = BaseHolder })
Collider.__index = Collider

function Collider:eats()
    return not self:held()
end

function Collider:update()
    if self:held() and not self:nudge() then self:_become() end
end

return Collider
