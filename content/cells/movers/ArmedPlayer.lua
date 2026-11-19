local Player = require("content/cells/movers/Player")
local FriendlyMissile = require("content/cells/missiles/FriendlyMissile")
local constants = require("src/constants")

local ArmedPlayer = setmetatable({
    name = "armedplayer",
    k3 = 845,
    title = "Armed Player",
    description = "Player that faces the way it moves and fires a Friendly Missile with Z or Enter.",
    faces = { 0 }
}, { __index = Player })
ArmedPlayer.__index = ArmedPlayer

function ArmedPlayer:update(_, direction)
    local simulator = self.simulator
    local input = simulator.input
    if direction ~= (input or 0) then return end

    if input then
        self:rotate(input - self.rotation, true)
        self:_move(unpack(constants.directions[input]))
    end
    if simulator.action then self:fire(FriendlyMissile) end
end

return ArmedPlayer
