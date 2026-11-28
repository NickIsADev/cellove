local Mover = require("content/cells/movers/Mover")
local constants = require("src/constants")

local SuperMover = setmetatable({
    name = "supermover",
    k3 = 284,
    title = "Super Mover",
    description = "A Mover with infinite force that moves infinitely fast.",
    subtick = { "superMover" }
}, { __index = Mover })
SuperMover.__index = SuperMover

function SuperMover:force(dx, dy, action)
    if action ~= "push" or self:_along(dx, dy) <= 0 then return 0 end
    return math.huge
end

function SuperMover:resist(force, dx, dy, action)
    if action == "push" and self:_along(dx, dy) < 0 then return 0 end
    return force
end

function SuperMover:update()
    for _ = 1, constants.grid.limits.max do
        if not self:push() then return end
    end
end

return SuperMover
