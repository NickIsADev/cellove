local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local late = { ccw = "gearCCW", ["180"] = "gear180", rng = "gearRNG" }

local BaseGear = setmetatable({
    faces = {},
    categories = { "gears" },
    subtick = { "gearCW" },
    sweep = { x = 1, y = -1 },
    sides = { orthogonal = true, diagonal = true },
    spin = 1,
    steps = 1,
    gear = true
}, { __index = BaseCell })
BaseGear.__index = BaseGear

function BaseGear:setup()
    local turn = late[self.name:match("_(%w+)$")]
    if turn and not self.forced then self.subtick, self.sweep = { turn }, { x = -1, y = -1 } end
end

function BaseGear:_ring(spin)
    local offsets, ring = constants.ring, {}

    for i = 1, #offsets do
        local offset = offsets[spin > 0 and i or #offsets + 1 - i]
        local diagonal = offset[1] ~= 0 and offset[2] ~= 0
        if self.sides[diagonal and "diagonal" or "orthogonal"] then
            ring[#ring + 1] = { self.x + offset[1], self.y + offset[2], diagonal = diagonal }
        end
    end
    return ring
end

function BaseGear:_stuck(cell, point)
    if point.diagonal then return cell.fixed end
    return not cell:swappable(self.x - point[1], self.y - point[2])
end

function BaseGear:_jammed(ring)
    local grid = self.simulator.grid

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell and (cell.gear or self:_stuck(cell, point)) then return true end
    end
end

function BaseGear:_turn(ring, spin)
    local grid = self.simulator.grid
    local corner = not self.sides.orthogonal

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell and point.diagonal == corner then cell:rotate(self.twist or spin, self.forced) end
    end
end

function BaseGear:update()
    local spin = self.random and utils.randomSign() or self.spin
    local ring = self:_ring(spin)
    if not self.forced and self:_jammed(ring) then return end

    for _ = 1, self.steps do
        if not self.simulator.movement:cycle(ring) then return end
        if not self.cog then self:_turn(ring, spin) end
    end
end

return BaseGear
