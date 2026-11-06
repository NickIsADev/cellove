local BaseHolder = require("content/cells/abstract/BaseHolder")

local Settlestorage = setmetatable({
    name = "settlestorage",
    k3 = 1150,
    title = "Settlestorage",
    description = "Stores the first cell that moves into it. Turns into it after a tick where it doesn't move.",
    faces = {},
    subtick = { 24 },
    sweep = { x = 1, y = -1 },
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

function Settlestorage:swapped()
    if not self:held() then self:absorb(self) end
end

function Settlestorage:update()
    local origin = self.path and self.path[1]
    local moved = origin ~= nil and (origin[1] ~= self.x or origin[2] ~= self.y)
    if self:held() and moved == self.moves and self.fed ~= self.simulator.time.tick then self:_become() end
end

return Settlestorage
