local Wall = require("content/cells/walls/Wall")

local Hallow = setmetatable({
    name = "hallow",
    k3 = 126,
    title = "Hallow",
    description = "Cannot be pushed, rotated, or destroyed. Turns any cell that tries to push it into another Hallow.",
    categories = { "walls", "infectious" }
}, { __index = Wall })
Hallow.__index = Hallow

function Hallow:bumped(dx, dy, pusher)
    if not (pusher and pusher:transformable(-dx, -dy)) then return end

    local movement = self.simulator.movement
    movement:defer(function()
        if self.grid:get(pusher.x, pusher.y) ~= pusher then return end

        movement:place(pusher.x, pusher.y, Hallow:new({ rotation = self.rotation }))
    end)
end

return Hallow
