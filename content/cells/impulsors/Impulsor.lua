local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Impulsor = setmetatable({
    name = "impulsor",
    k3 = 29,
    title = "Impulsor",
    description = "Pulls the cell two tiles away from it on every side one tile closer every tick.",
    categories = { "impulsors" },
    subtick = { "impulsor" },
    directional = true,
    inputs = {  0, 1, 2, 3  }
}, { __index = BaseCell })
Impulsor.__index = Impulsor

function Impulsor:setup()
    self.faces, self.outputs = self.inputs, {}

    for _, side in ipairs(self.inputs) do
        self.outputs[#self.outputs + 1] = (side + 2) % 4
    end
end

function Impulsor:update(_, direction)
    local near = self:look((direction + 2) % 4, true)
    if not near then return end

    self.simulator.movement:attract(near.x + near.dx, near.y + near.dy, -near.dx, -near.dy, constants.force.strength, self.row)
end

return Impulsor
