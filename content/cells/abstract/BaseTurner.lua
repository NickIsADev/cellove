local Pushable = require("content/cells/pushables/Pushable")

local BaseTurner = setmetatable({
    categories = { "rotators" },
    spin = 1
}, { __index = Pushable })
BaseTurner.__index = BaseTurner

function BaseTurner:_spin(cell)
    cell:rotate(self.spin, false, true)
end

function BaseTurner:chained(action)
    if action ~= "push" then return end

    local movement, x, y = self.simulator.movement, self.x, self.y
    movement:post(function(moved)
        local pusher = moved and self.grid:get(x, y)
        if pusher and pusher ~= self then self:_spin(pusher) end
    end)
end

return BaseTurner
