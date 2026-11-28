local BaseHolder = require("content/cells/abstract/BaseHolder")

local Storage = setmetatable({
    name = "storage",
    k3 = 165,
    title = "Storage",
    description = "Stores the cell that moves into it until another cell bumps it out.",
    fixed = true,
    anchored = true
}, { __index = BaseHolder })
Storage.__index = Storage

function Storage:_eject(old, dx, dy)
    if not old.class then return end

    local cell = self:_cell(old)

    self.simulator.movement:defer(function()
        self.simulator.movement:release(self.x, self.y, dx, dy, cell, { mode = "eject" })
    end)
end

function Storage:eats(dx, dy, action)
    return action ~= nil or not self:held() or self.grid.simulator.movement:clear(self.x, self.y, dx, dy)
end

function Storage:ate(cell, dx, dy)
    local old = self.props.stored
    BaseHolder.ate(self, cell)
    self:_eject(old, dx, dy)
end

function Storage:swapped(dx, dy)
    self:ate(self, dx, dy)
end

function Storage:bumped(dx, dy)
    if not self:eats(dx, dy) then return end

    local old = self.props.stored
    self:_hold({})
    self:_eject(old, dx, dy)
end

return Storage
