local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local BaseHolder = require("content/cells/abstract/BaseHolder")
local constants = require("src/constants")

local FilterDiverger = setmetatable({
    name = "filterdiverger",
    k3 = 233,
    title = "Filter Diverger",
    description = "Lets cells pass straight through along its axis, except cells of the same type as the one inserted into its side, which it deletes.",
    categories = { "divergers" },
    destroys = true,
    faces = { 0, 2 },
    fit = constants.renderer.stored.memory,
    upright = true,
    _entry = BaseDiverger._entry
}, { __index = BaseHolder })
FilterDiverger.__index = FilterDiverger

function FilterDiverger:_matches(mover)
    return self:held() and getmetatable(mover) == self.props.stored.class
end

function FilterDiverger:_blocks(mover)
    return self:_matches(mover)
end

function FilterDiverger:divert(dx, dy, _, mover)
    if self:_entry(dx, dy) % 2 == 0 and not self:_blocks(mover) then return dx, dy, 0 end
end

function FilterDiverger:eats(dx, dy, action, mover)
    return not action and (self:_entry(dx, dy) % 2 == 1 or mover ~= nil and self:_blocks(mover))
end

function FilterDiverger:ate(cell, dx, dy)
    if self:_entry(dx, dy) % 2 == 1 then BaseHolder.ate(self, cell) end
end

return FilterDiverger
