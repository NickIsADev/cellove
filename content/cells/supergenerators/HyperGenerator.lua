local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")
local constants = require("src/constants")

local HyperGenerator = setmetatable({
    name = "hypergenerator",
    k3 = 448,
    title = "Hyper Generator",
    description = "Generates an entire structure.",
    subtick = { "hyperGenerator" }
}, { __index = SuperGenerator })
HyperGenerator.__index = HyperGenerator

function HyperGenerator:update(_, direction)
    local grid = self.grid
    local facing = constants.directions[direction]
    local dx, dy, x, y = facing[1], facing[2], self.x, self.y

    local function depth(px, py)
        return (x - px) * dx + (y - py) * dy
    end

    local seed = grid:get(x - dx, y - dy)
    if not (seed and seed:cloneable()) then return end

    local lanes, deepest = {}, 0
    local points = grid:flood(x - dx, y - dy, function(cell, px, py)
        return cell and cell:cloneable() and depth(px, py) > 0
    end)

    for _, point in ipairs(points) do
        local lane = dx ~= 0 and point[2] or point[1]
        local far = depth(point[1], point[2])

        lanes[lane] = lanes[lane] or {}
        lanes[lane][far] = grid:get(point[1], point[2])
        deepest = math.max(deepest, far)
    end

    for lane, row in pairs(lanes) do
        local at = { x = dx ~= 0 and x or lane, y = dx ~= 0 and lane or y, dx = dx, dy = dy }

        for far = deepest, 1, -1 do
            at = self:_lay(at, row[far], 0, self.pushing)
            if not at then break end
        end
    end
end

return HyperGenerator
