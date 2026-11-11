local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Magnet = setmetatable({
    name = "magnet",
    k3 = 156,
    title = "Magnet",
    description = "Pushes away magnets facing the opposite way next to it and pulls in magnets facing the same way from two tiles away, in front of and behind itself.",
    categories = { "forces" },
    subtick = { "magnetX", "magnetY" },
    sweep = { x = 1, y = -1 },
    magnet = true
}, { __index = BaseCell })
Magnet.__index = Magnet

function Magnet:_reach(direction)
    local grid, movement = self.simulator.grid, self.simulator.movement
    local facing = constants.directions[direction]
    local x, y = self.x + facing[1], self.y + facing[2]
    local near = grid:get(x, y)

    if near then
        return near.magnet and near.rotation == (self.rotation + 2) % 4 and self:repel(direction)
    end

    local far = movement:look(x, y, facing[1], facing[2], true)
    local target = far and far.target

    if target and target.magnet and target.rotation == self.rotation then
        movement:attract(far.x, far.y, -far.dx, -far.dy, constants.force.strength)
    end
end

function Magnet:update(subtick)
    if (self.rotation % 2 == 0) ~= (subtick == self.subtick[1]) then return end

    local grid, x, y = self.simulator.grid, self.x, self.y

    self:_reach(self.rotation)
    if grid:get(x, y) == self then self:_reach((self.rotation + 2) % 4) end
end

return Magnet
