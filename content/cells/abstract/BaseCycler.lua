local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local BaseCycler = setmetatable({
    categories = { "cyclers" },
    subtick = { "cyclerCW" },
    sweep = {
        cyclerCW = {
            [0] = { x = 1, y = -1, columns = true },
            [2] = { x = -1, y = 1, columns = true },
            [3] = { x = -1, y = -1 },
            [1] = { x = 1, y = 1 }
        },
        cyclerCCW = {
            [0] = { x = 1, y = 1, columns = true },
            [2] = { x = -1, y = -1, columns = true },
            [3] = { x = 1, y = -1 },
            [1] = { x = -1, y = 1 }
        }
    },
    directional = true,
    spin = 1
}, { __index = BaseCell })
BaseCycler.__index = BaseCycler

function BaseCycler:_cycle(direction, spin)
    local facing = constants.directions[direction]
    local dx, dy = facing[1], facing[2]
    local grid, ring = self.simulator.grid, {}

    for side = -spin, spin, spin do
        ring[#ring + 1] = { self.x + dx - dy * side, self.y + dy + dx * side }
    end

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell and not cell:swappable(dx, dy) then return end
    end
    return self.simulator.movement:cycle(ring)
end

function BaseCycler:update(_, direction)
    return self:_cycle(direction, self.spin)
end

return BaseCycler
