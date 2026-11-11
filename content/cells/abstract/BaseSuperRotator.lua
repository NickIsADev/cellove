local BaseRotator = require("content/cells/abstract/BaseRotator")

local BaseSuperRotator = setmetatable({
    subtick = { "superRotator" }
}, { __index = BaseRotator })
BaseSuperRotator.__index = BaseSuperRotator

function BaseSuperRotator:update()
    local grid, spin = self.simulator.grid, self:_spin()
    local area = grid:flood(self.x, self.y, function(cell) return cell and not cell.anchored end)

    for _, point in ipairs(area) do
        local cell = grid:get(point[1], point[2])
        if cell ~= self then cell:rotate(spin) end
    end
end

return BaseSuperRotator
