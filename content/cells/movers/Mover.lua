local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Mover = setmetatable({
    name = "mover",
    k3 = 2,
    title = "Mover",
    description = "Moves forward every tick, pushing whatever is in front of it.",
    categories = { "movers" },
    subtick = { 3 },
    drive = { push = true, pull = true },
    directional = true
}, { __index = BaseCell })
Mover.__index = Mover

function Mover:force(dx, dy, action)
    if action == "pull" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Mover:update()
    self:push()
end

return Mover
