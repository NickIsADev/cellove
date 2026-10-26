local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Advancer = setmetatable({
    name = "advancer",
    k3 = 28,
    title = "Advancer",
    description = "Moves forward every tick, pushing whatever is in front of it and pulling everything behind it.",
    categories = { "movers", "pullers" },
    subtick = { 3 },
    drive = { push = true, pull = true },
    directional = true
}, { __index = BaseCell })
Advancer.__index = Advancer

function Advancer:force(dx, dy)
    return self:_alignment(dx, dy) * constants.force.strength
end

function Advancer:update()
    self:advance()
end

return Advancer
