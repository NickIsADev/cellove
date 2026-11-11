local Wall = require("content/cells/walls/Wall")

local Staller = setmetatable({
    name = "staller",
    k3 = 162,
    title = "Staller",
    description = "Cannot be pushed or rotated, but is destroyed when something tries to move into it."
}, { __index = Wall })
Staller.__index = Staller

function Staller:bump()
    self.simulator.movement:destroy(self, true)
end

return Staller
