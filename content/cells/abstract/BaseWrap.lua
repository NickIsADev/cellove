local BaseCell = require("content/cells/abstract/BaseCell")
local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local BaseWrap = setmetatable({
    categories = { "wraps" },
    faces = {},
    fixed = true,
    anchored = true,
    _entry = BaseDiverger._entry
}, { __index = BaseCell })
BaseWrap.__index = BaseWrap

function BaseWrap:_lands(dx, dy, scan)
    return self.jumps[(self:_entry(dx, dy) + 2) % 4] == scan
end

function BaseWrap:jump(dx, dy, x, y)
    local scan = self.jumps[self:_entry(dx, dy)]
    if not scan then return end

    local grid, inside = self.grid
    repeat
        x, y = x + scan * dx, y + scan * dy
        inside = grid:bounds(x, y)
        local target = inside and grid:get(x, y)
    until not inside or target and target.jumps and target:_lands(dx, dy, scan)

    if inside or scan < 0 then return x, y end
end

return BaseWrap
