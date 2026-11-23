local Mover = require("content/cells/movers/Mover")

local Remover = setmetatable({
    name = "remover",
    k3 = 303,
    title = "Remover",
    description = "Mover that deletes the cell in front of it when it cannot push. Cannot delete protected cells."
}, { __index = Mover })
Remover.__index = Remover

function Remover:update()
    if self:push() then return end

    local target = self:_breakable()
    if not target then return end

    target:kill()
    self:push()
end

return Remover
