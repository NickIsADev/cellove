local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local utils = require("src/utils")

local BaseForker = setmetatable({
    categories = { "forkers" },
    destroys = true,
    rotates = false,
    routes = {}
}, { __index = BaseDiverger })
BaseForker.__index = BaseForker

function BaseForker:_copies()
    return 1
end

function BaseForker:eats(dx, dy, action)
    return not action and self.forks[self:_entry(dx, dy)] ~= nil
end

function BaseForker:ate(cell, dx, dy)
    local class, props = cell:template()
    local forks = self.forks[self:_entry(dx, dy)]
    if not (class and forks) then return end

    local x, y, movement = self.x, self.y, self.simulator.movement
    local effects, rotation, updated, ran = cell:permanent(), cell.rotation, cell.updated, cell.ran
    local copies = self:_copies()

    movement:defer(function()
        for _ = 1, copies do
            for _, bend in ipairs(forks) do
                local clone = class:new({ rotation = rotation, props = props, effects = effects })
                clone:rotate(self.rotates and bend or 0, { forced = true, quiet = true })
                clone.updated, clone.ran = updated, ran

                local nx, ny = utils.turn(dx, dy, bend)
                movement:release(x, y, nx, ny, clone)
            end
        end
    end)
end

return BaseForker
