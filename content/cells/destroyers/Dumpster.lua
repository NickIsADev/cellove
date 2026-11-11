local Trash = require("content/cells/destroyers/Trash")
local constants = require("src/constants")

local Dumpster = setmetatable({
    name = "dumpster",
    k3 = 436,
    title = "Dumpster",
    description = "Deletes any cell that moves into it. Every tick, also deletes every cell in the row or column it faces, up to the nearest immovable cell.",
    subtick = { "dumpster" },
    outputs = { 0, 2 }
}, { __index = Trash })
Dumpster.__index = Dumpster

function Dumpster:_clear(direction)
    local grid, movement = self.simulator.grid, self.simulator.movement
    local facing = constants.directions[direction]
    local x, y = self.x + facing[1], self.y + facing[2]
    local cell = grid:get(x, y)

    while not (cell and cell.fixed) do
        if cell then movement:destroy(cell) end
        x, y = x + facing[1], y + facing[2]
        cell = grid:get(x, y)
    end
end

function Dumpster:update()
    for _, offset in ipairs(self.outputs) do
        self:_clear((self.rotation + offset) % 4)
    end
end

return Dumpster
