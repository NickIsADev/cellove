local BaseCell = require("content/cells/abstract/BaseCell")

local BaseRPS = setmetatable({
    categories = { "infectious" },
    subtick = { "spread" }
}, { __index = BaseCell })
BaseRPS.__index = BaseRPS

function BaseRPS:_spawn(x, y)
    local class, props = self:generated()
    local clone = class:new({ rotation = self.rotation, props = props })

    clone.updated = self.simulator.time.tick
    self.simulator.movement:place(x, y, clone)
end

function BaseRPS:update()
    self:neighbors(1, function(cell, x, y)
        if not cell or cell.name == self.beats then self:_spawn(x, y) end
    end)
end

return BaseRPS
