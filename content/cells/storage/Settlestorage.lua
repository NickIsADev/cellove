local BaseHolder = require("content/cells/abstract/BaseHolder")

local Settlestorage = setmetatable({
    name = "settlestorage",
    k3 = 1150,
    title = "Settlestorage",
    description = "Stores the first cell that moves into it. Turns into it after a tick where it doesn't move.",
    subtick = { 6 },
    moves = false
}, { __index = BaseHolder })
Settlestorage.__index = Settlestorage

function Settlestorage:eats()
    return not self:held()
end

function Settlestorage:absorb(cell)
    BaseHolder.absorb(self, cell)
    self.fed = self.simulator.time.tick
end

function Settlestorage:update()
    local moved = self.path ~= nil
    if self:held() and moved == getmetatable(self).moves and self.fed ~= self.simulator.time.tick then self:_become() end
end

return Settlestorage
