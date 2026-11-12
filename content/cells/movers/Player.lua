local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Player = setmetatable({
    name = "player",
    k3 = 239,
    title = "Player",
    description = "Moves with the arrow keys or WASD while the simulation runs, pushing whatever is in front of it. A puzzle is failed if every Player is destroyed, unless all Enemies are defeated at the same time.",
    faces = {},
    player = true,
    fragile = false,
    categories = { "players" },
    subtick = { "player" },
    directional = true,
    outputs = { 0, 1, 2, 3 }
}, { __index = BaseCell })
Player.__index = Player

function Player:_move(dx, dy)
    self:push(dx, dy, constants.force.strength)
end

function Player:eats()
    return self.fragile
end

function Player:absorb()
    self:kill(true)
end

function Player:update(_, direction)
    if direction == self.simulator.input then self:_move(unpack(constants.directions[direction])) end
end

return Player
