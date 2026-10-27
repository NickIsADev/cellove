local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local late = utils.set({ "ccw", "180", "rng" })

local BaseGear = setmetatable({
    categories = { "rotators", "gears" },
    subtick = { 1 },
    sides = { orthogonal = true, diagonal = true },
    spin = 1,
    steps = 1,
    gear = true
}, { __index = BaseCell })
BaseGear.__index = BaseGear

function BaseGear:setup()
    if not late[self.name:match("_(%w+)$")] then return end
    self.subtick, self.sweep = { 2 }, constants.simulator.sweeps.leftup
end

function BaseGear:_ring(spin)
    local class = getmetatable(self)
    local offsets, ring = constants.ring, {}

    for i = 1, #offsets do
        local offset = offsets[spin > 0 and i or #offsets + 1 - i]
        local diagonal = offset[1] ~= 0 and offset[2] ~= 0
        if class.sides[diagonal and "diagonal" or "orthogonal"] then
            ring[#ring + 1] = { self.x + offset[1], self.y + offset[2], diagonal = diagonal }
        end
    end
    return ring
end

function BaseGear:_jammed(ring)
    local grid = self.simulator.grid

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell and cell.gear then return true end
    end
end

function BaseGear:_turn(ring, spin)
    local class = getmetatable(self)
    local grid = self.simulator.grid
    local corner = not class.sides.orthogonal

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell and point.diagonal == corner then cell:rotate(class.turn or spin) end
    end
end

function BaseGear:update()
    local class = getmetatable(self)
    local spin = class.random and math.random(0, 1) * 2 - 1 or class.spin
    local ring = self:_ring(spin)
    if not class.forced and self:_jammed(ring) then return end

    for _ = 1, class.steps do
        if not self.simulator.movement:cycle(ring, class.forced) then return end
        if not class.cog then self:_turn(ring, spin) end
    end
end

return BaseGear
