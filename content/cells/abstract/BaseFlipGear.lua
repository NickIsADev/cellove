local BaseGear = require("content/cells/abstract/BaseGear")
local constants = require("src/constants")

local flip = constants.flip

local BaseFlipGear = setmetatable({
    axis = "straight"
}, { __index = BaseGear })
BaseFlipGear.__index = BaseFlipGear

function BaseFlipGear:_key()
    return (self.rotation * 2 + flip.shift[getmetatable(self).axis]) % 4
end

function BaseFlipGear:_swaps(ring, key)
    local matrix = flip.reflections[key]
    local swaps = {}

    for _, point in ipairs(ring) do
        local dx, dy = point[1] - self.x, point[2] - self.y
        local mx = matrix[1] * dx + matrix[2] * dy
        local my = matrix[3] * dx + matrix[4] * dy
        if dy * 3 + dx < my * 3 + mx then swaps[#swaps + 1] = { point[1], point[2], self.x + mx, self.y + my } end
    end
    return swaps
end

function BaseFlipGear:_flip(ring, key)
    local grid = self.simulator.grid

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell then cell:rotate(key - 2 * cell.rotation) end
    end
end

function BaseFlipGear:update()
    local ring = self:_ring(1)
    local key = self:_key()
    if self:_jammed(ring) or not self.simulator.movement:exchange(self:_swaps(ring, key)) then return end
    if not getmetatable(self).cog then self:_flip(ring, key) end
end

return BaseFlipGear
