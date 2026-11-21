local Shifter = require("content/cells/shifters/Shifter")
local constants = require("src/constants")
local utils = require("src/utils")

local limit = 5

local SniperShifter = setmetatable({
    name = "snipershifter",
    k3 = 847,
    title = "Sniper Shifter",
    description = "Shifter that pushes the outputted cell forward until it is blocked."
}, { __index = Shifter })
SniperShifter.__index = SniperShifter

function SniperShifter:_emit(facing, scout)
    local generated, clone = Shifter._emit(self, facing, scout)
    if not generated then return end

    local grid = self.grid
    local heading = constants.directions[facing]
    local dx, dy = heading[1], heading[2]
    local crossings = {}

    while clone and grid:get(clone.x, clone.y) == clone do
        local index = (clone.y - 1) * grid.width + clone.x
        if (crossings[index] or 0) >= limit then break end
        crossings[index] = (crossings[index] or 0) + 1

        local rotation = clone.rotation
        if not clone:push(dx, dy, constants.force.strength) then break end
        dx, dy = utils.turn(dx, dy, clone.rotation - rotation)
    end
    return true
end

return SniperShifter
