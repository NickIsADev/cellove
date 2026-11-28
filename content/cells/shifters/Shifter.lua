local BaseTransformer = require("content/cells/abstract/BaseTransformer")
local constants = require("src/constants")
local utils = require("src/utils")

local Shifter = setmetatable({
    name = "shifter",
    k3 = 106,
    title = "Shifter",
    description = "Like a Generator, but pulls the cell behind it out of place instead of cloning it.",
    categories = { "shifters" },
    subtick = { "shifter" }
}, { __index = BaseTransformer })
Shifter.__index = Shifter

function Shifter:_shiftable(scout)
    local cell = scout and scout.cell
    return cell and cell:pushable(-scout.dx, -scout.dy, nil, "pull") and not cell:guarded("pull")
end

function Shifter:_emit(facing, scout)
    local source, turn = self:_plan(facing)
    return self:generate(facing, { source = source, turn = turn, cell = scout.cell })
end

function Shifter:_retreat(direction)
    local scout, turn = self:_scout(direction)
    if not self:_shiftable(scout) then return end

    local grid, cell = self.grid, scout.cell
    local back, front = constants.directions[(direction + 2) % 4], constants.directions[direction]

    grid:set(scout.x, scout.y)
    if self:push(back[1], back[2], { force = constants.force.strength }) then
        return self.simulator.movement:release(self.x, self.y, front[1], front[2], self:_build(scout, turn))
    end

    grid:set(scout.x, scout.y, cell)
end

function Shifter:update(_, direction)
    local stamp = self.simulator.time.subtick
    if self.rear then
        if self.stamp == stamp then return end
        self.stamp = stamp
    end

    local scout = self:_scout(direction)
    if not self:_shiftable(scout) then
        if scout and self.reverses then self:flip(utils.flip(direction, "straight")) end
        return
    end

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

    local shifted
    for _, facing in ipairs(open) do
        shifted = self:_emit(facing, scout) or shifted
    end
    return shifted
end

return Shifter
