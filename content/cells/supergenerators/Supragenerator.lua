local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")
local constants = require("src/constants")

local Supragenerator = setmetatable({
    name = "supragenerator",
    k3 = 1115,
    title = "Supragenerator",
    description = "Generates an entire column.",
    subtick = { "hyperGenerator" }
}, { __index = SuperGenerator })
Supragenerator.__index = Supragenerator

function Supragenerator:update(_, direction)
    local movement = self.simulator.movement
    local facing = constants.directions[direction]
    local options = self.pushing

    local back = self:look((direction + 2) % 4, true)
    local target = back and back.target
    if not (target and target:cloneable()) then return end

    local sx, sy, turn = back.x, back.y, back.turn
    self:_lay({ x = self.x, y = self.y, dx = facing[1], dy = facing[2] }, target, turn, options)

    for _, side in ipairs({ 1, 3 }) do
        local lateral = constants.directions[(direction + side) % 4]
        local x, y, bent = sx, sy, turn

        for step = 1, constants.grid.limits.max do
            local look = movement:look(x, y, lateral[1], lateral[2], true)
            local cell = look and look.target
            if not (cell and cell:cloneable()) then break end

            bent = bent + look.turn
            x, y = look.x, look.y

            local at = { x = self.x + step * lateral[1], y = self.y + step * lateral[2], dx = facing[1], dy = facing[2] }
            self:_lay(at, cell, bent, options)
        end
    end
end

return Supragenerator
