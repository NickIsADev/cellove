local BaseEffect = require("content/effects/abstract/BaseEffect")
local Thawed = require("content/effects/Thawed")

local Frozen = setmetatable({
    name = "frozen"
}, { __index = BaseEffect })
Frozen.__index = Frozen

function Frozen:accepts(cell)
    return BaseEffect.accepts(self, cell) and not cell:effect(Thawed)
end

function Frozen:applied(cell)
    if not cell.freezes then cell.updated = cell.grid.simulator.time.tick end
end

return Frozen
