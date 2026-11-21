local BaseExtension = require("content/cells/abstract/BaseExtension")
local constants = require("src/constants")

local GrabExtension = setmetatable({
    name = "grabextension",
    k3 = 477,
    title = "Grab Extension",
    description = "When moved by any force, it extends that force: it grabs the cells at its sides and carries them in the direction it moved."
}, { __index = BaseExtension })
GrabExtension.__index = GrabExtension

function GrabExtension:force(_, _, action)
    return action == "grab" and constants.force.strength or 0
end

function GrabExtension:_extend(dx, dy)
    self:grab(dx, dy)
end

function GrabExtension:chained(action, dx, dy)
    if action == "grab" then return end

    local movement, x, y = self.simulator.movement, self.x, self.y
    movement:post(function(moved)
        if moved or action == "pull" then movement:flank(x, y, dx, dy) end
    end)
end

return GrabExtension
