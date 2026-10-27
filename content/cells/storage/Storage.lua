local BaseHolder = require("content/cells/abstract/BaseHolder")

local Storage = setmetatable({
    name = "storage",
    k3 = 165,
    title = "Storage",
    description = "Stores the cell that moves into it until another cell bumps it out."
}, { __index = BaseHolder })
Storage.__index = Storage

function Storage:pushable()
    return false
end

function Storage:transformable()
    return false
end

function Storage:absorb(cell, dx, dy)
    local old = self.props.stored
    BaseHolder.absorb(self, cell)
    if not old.class then return end

    self.simulator.movement:defer(function()
        self.simulator.movement:release(self.x, self.y, dx, dy, self:_cell(old))
    end)
end

return Storage
