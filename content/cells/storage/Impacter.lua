local Collider = require("content/cells/storage/Collider")
local Mover = require("content/cells/movers/Mover")

local Impacter = setmetatable({
    name = "impacter",
    k3 = 905,
    title = "Impacter",
    description = "Collider that pushes.",
    categories = {
        "movers",
        "othermovers",
        "storage"
    },
    subtick = { "mover" },
    rear = true
}, { __index = Collider })
Impacter.__index = Impacter

function Impacter:force(dx, dy, action)
    if not self:held() then return 0 end
    return Mover.force(self, dx, dy, action)
end

function Impacter:update()
    if self:held() and not self:push() then self:_become() end
end

return Impacter
