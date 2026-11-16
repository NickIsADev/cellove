local BaseEffect = require("content/effects/abstract/BaseEffect")

local Goo = setmetatable({
    name = "goo",
    permanent = true,
    subtick = { "goo", "compel" }
}, { __index = BaseEffect })
Goo.__index = Goo

function Goo:update(cell, _, subtick)
    if subtick == self.subtick[1] then
        cell.updated = cell.grid.simulator.time.tick
    elseif cell:moved() then
        self:remove(cell)
    end
end

return Goo
