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
    local routes = reverse and self.reverse or self.routes

    local entry = self:_entry(dx, dy)
    local bend = routes[entry]
    if type(bend) == "table" then bend = bend[math.random(#bend)] end
    if not bend then return end

    local nx, ny = utils.turn(dx, dy, bend)
    local halt = reverse and self.halts and self.halts[entry]
    return nx, ny, self.rotates and bend or 0, halt
end

return BaseDiverger
