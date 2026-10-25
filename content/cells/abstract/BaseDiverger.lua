local BaseCell = require("content/cells/abstract/BaseCell")
local utils = require("src/utils")

local BaseDiverger = setmetatable({
    categories = { "divergers" },
    rotates = true
}, { __index = BaseCell })
BaseDiverger.__index = BaseDiverger

function BaseDiverger:_entry(dx, dy)
    local along = self:_alignment(dx, dy)
    if along ~= 0 then return 1 + along end

    return 2 + self:_side(dx, dy)
end

function BaseDiverger:divert(dx, dy, reverse)
    local class = getmetatable(self)
    local routes = reverse and class.reverse or class.routes

    local bend = routes[self:_entry(dx, dy)]
    if type(bend) == "table" then bend = bend[math.random(#bend)] end
    if not bend then return end

    local nx, ny = utils.turn(dx, dy, bend)
    return nx, ny, class.rotates and bend or 0
end

return BaseDiverger
