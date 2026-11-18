local BaseTransformer = require("content/cells/abstract/BaseTransformer")
local constants = require("src/constants")

local Shifter = setmetatable({
    name = "shifter",
    k3 = 106,
    title = "Shifter",
    description = "Like a Generator, but pulls the cell behind it out of place instead of cloning it.",
    categories = { "shifters" },
    subtick = { "shifter" }
}, { __index = BaseTransformer })
Shifter.__index = Shifter

function Shifter:update(_, direction)
    local stamp = self.simulator.time.subtick
    if self.rear then
        if self.stamp == stamp then return end
        self.stamp = stamp
    end

    local scout = self:_scout(direction)
    local cell = scout and scout.cell
    if not (cell and cell:pushable(-scout.dx, -scout.dy) and not cell:guarded("pull")) then return end

    local facings = { direction }
    if self.rear then
        facings = {}
        for _, output in ipairs(self.outputs) do
            facings[#facings + 1] = (self.rotation + output) % 4
        end
    end

    local movement = self.simulator.movement
    local open = {}
    for _, facing in ipairs(facings) do
        local heading = constants.directions[facing]
        if movement:clear(self.x, self.y, heading[1], heading[2]) then open[#open + 1] = facing end
    end
    if #open == 0 or not self:_withdraw(scout) then return end

    for _, facing in ipairs(open) do
        local source, turn = self:_plan(facing)
        self:generate(facing, { source = source, turn = turn, cell = cell })
    end
end

return Shifter
