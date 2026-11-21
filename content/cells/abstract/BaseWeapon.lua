local Enemy = require("content/cells/destroyers/Enemy")
local constants = require("src/constants")

local crossings, warning = 5, 4

local function hit(cell)
    if cell then cell:hit() end
end

local BaseWeapon = setmetatable({
    faces = { 0 },
    hostile = false,
    team = "hostile"
}, { __index = Enemy })
BaseWeapon.__index = BaseWeapon

function BaseWeapon:_burst()
    if not self.blast then return end

    local grid = self.grid
    local movement = grid.simulator.movement
    grid[self.blast](grid, self.x, self.y, 1, function(cell)
        if not cell then return end

        movement:defer(function()
            if grid:get(cell.x, cell.y) == cell then cell:hit(1) end
        end)
    end)
end

function BaseWeapon:_hunts(cell)
    local side = cell:side()
    return side and side ~= self.team
end

function BaseWeapon:_incoming(cell, distance, dx, dy)
    local facing = constants.directions[cell.rotation]
    return cell.unsmart and distance <= warning and facing[1] == -dx and facing[2] == -dy
end

function BaseWeapon:_scan(direction, limit)
    local movement, grid = self.simulator.movement, self.grid
    local facing = constants.directions[direction]
    local x, y, dx, dy = self.x, self.y, facing[1], facing[2]

    for distance = 1, limit do
        local front = movement:look(x, y, dx, dy)
        if not front then return end

        x, y, dx, dy = front.x, front.y, front.dx, front.dy
        local cell = grid:get(x, y)
        if cell and not cell.hollow then return cell, distance, dx, dy end
    end
end

function BaseWeapon:_target(range, shots)
    local nearest, aim = math.huge
    local limit = range > 0 and range or crossings * self.grid.width * self.grid.height

    for direction = 0, 3 do
        local cell, distance, dx, dy = self:_scan(direction, limit)
        local wanted = cell and (self:_hunts(cell) or shots and self:_incoming(cell, distance, dx, dy))

        if wanted and distance < nearest then nearest, aim = distance, direction end
    end
    return aim
end

function BaseWeapon:health()
    return self.tough and math.huge or self.weak and 2 or 1
end

function BaseWeapon:struck(damage)
    if damage < self:health() then
        if self.weak then setmetatable(self, self.weak) end
        return true
    end
    self:_burst()
end

function BaseWeapon:hit(damage)
    if damage >= self:health() then self:kill(true) end
    self:struck(damage)
end

return BaseWeapon
