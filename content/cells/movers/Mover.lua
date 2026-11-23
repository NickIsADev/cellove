local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Mover = setmetatable({
    name = "mover",
    k3 = 2,
    title = "Mover",
    description = "Moves forward every tick, pushing whatever is in front of it.",
    categories = { "movers" },
    subtick = { "mover" },
    rear = true,
    drive = { push = true, pull = true, grab = true },
    directional = true
}, { __index = BaseCell })
Mover.__index = Mover

function Mover:force(dx, dy, action)
    if action ~= "push" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Mover:_breakable()
    local front = self:look(self.rotation)
    local target = front and front.target

    if target and target:breakable() and not target:guarded("protect", front.dx, front.dy) then return target end
end

function Mover:update()
    self:push(nil, nil, nil, self.options)
end

return Mover
