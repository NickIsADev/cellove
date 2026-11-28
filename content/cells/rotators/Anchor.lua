local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local none = {}
local spins = { { 0, -1, 1, 0 }, { -1, 0, 0, -1 }, { 0, 1, -1, 0 } }

local Anchor = setmetatable({
    name = "anchor",
    k3 = 447,
    title = "Anchor",
    description = "Rotates and flips everything attached to it around itself.",
    categories = { "otherrotators" },
    faces = {},
    turns = true
}, { __index = BaseCell })
Anchor.__index = Anchor

function Anchor:_pivot(matrix, apply)
    local grid, a, b, c, d = self.grid, unpack(matrix)
    local area = grid:flood(self.x, self.y, function(cell) return cell and not cell.fixed and not cell:guarded("swap") end)
    local points = {}

    for i, point in ipairs(area) do
        local ox, oy = point[1] - self.x, point[2] - self.y
        points[i] = { point[1], point[2], self.x + a * ox + b * oy, self.y + c * ox + d * oy }
    end

    self.simulator.movement:relocate(points, function()
        for _, point in ipairs(area) do
            local cell = grid:get(point[1], point[2])
            if self.turns and cell ~= self then apply(cell) end
        end
    end)
end

function Anchor:_run(matrix, apply)
    self.simulator.movement:defer(function()
        if self.grid:get(self.x, self.y) == self then self:_pivot(matrix, apply) end
    end)
end

function Anchor:rotated(amount)
    local turn = amount % 4
    if turn ~= 0 then self:_run(spins[turn], function(cell) cell:rotate(turn, { quiet = true }) end) end
end

function Anchor:flip(key, options)
    options = options or none
    if options.quiet or self:guarded("lock") and not options.forced then return end
    self:_run(constants.flip.reflections[key], function(cell) cell:flip(key, { quiet = true }) end)
end

return Anchor
