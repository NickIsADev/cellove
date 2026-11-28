local BaseExtension = require("content/cells/abstract/BaseExtension")
local constants = require("src/constants")

local PullExtension = setmetatable({
    name = "pullextension",
    k3 = 464,
    title = "Pull Extension",
    description = "When moved by any force, it extends that force: it pulls the cells behind it forward in the direction it moved."
}, { __index = BaseExtension })
PullExtension.__index = PullExtension

function PullExtension:_extend(dx, dy)
    self:pull(dx, dy, { force = constants.force.strength })
end

function PullExtension:chained(action, dx, dy, anchor)
    local movement, x, y = self.simulator.movement, self.x - dx, self.y - dy
    if action == "grab" then
        movement:post(function() movement:pull(x, y, dx, dy, { force = constants.force.unit }) end)
    elseif action == "push" and not anchor.extended then
        anchor.extended = true
        x, y, dx, dy = anchor.x - anchor.dx, anchor.y - anchor.dy, anchor.dx, anchor.dy
        movement:post(function() movement:pull(x, y, dx, dy, { force = constants.force.unit }) end)
    end
end

return PullExtension
