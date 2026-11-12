local Driller = require("content/cells/drillers/Driller")

local Trespasser = setmetatable({
    name = "trespasser",
    k3 = 1162,
    title = "Trespasser",
    description = "Swaps places with the last cell in the row in front of it."
}, { __index = Driller })
Trespasser.__index = Trespasser

function Trespasser:drill()
    local x, y, dx, dy = self.x, self.y, self:_aim()
    local grid, steps = self.grid, 0
    local cell = grid:get(x + dx, y + dy)

    while cell and cell:swappable(dx, dy) do
        steps = steps + 1
        cell = grid:get(x + dx * (steps + 1), y + dy * (steps + 1))
    end

    if steps == 0 and not cell and grid:bounds(x + dx, y + dy) then steps = 1 end
    return steps > 0 and self:swap(0, 0, dx * steps, dy * steps)
end

return Trespasser
