local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Player = setmetatable({
    name = "player",
    k3 = 239,
    title = "Player",
    description = "Moves with the arrow keys or WASD while the simulation runs, pushing whatever is in front of it. A puzzle is failed if every Player is destroyed, unless all Enemies are defeated at the same time.",
    faces = {},
    player = true,
    categories = { "players" },
    subtick = { 36 },
    directional = true,
    outputs = { 0, 1, 2, 3 }
}, { __index = BaseCell })
Player.__index = Player

function Player:update(_, direction)
    if direction ~= self.simulator.input then return end

    local dx, dy = unpack(constants.directions[direction])
    self:push(dx, dy, constants.force.strength)
end

return Player
