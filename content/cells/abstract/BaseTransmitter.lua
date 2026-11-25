local BaseCell = require("content/cells/abstract/BaseCell")

local wave

local BaseTransmitter = setmetatable({
    categories = { "effects" },
    transmits = true
}, { __index = BaseCell })
BaseTransmitter.__index = BaseTransmitter

function BaseTransmitter:_linked(cell)
end

function BaseTransmitter:_targets(wide)
    local targets = {}

    self.grid[wide and "surrounding" or "neighbors"](self.grid, self.x, self.y, 1, function(cell)
        if cell and not self:_linked(cell) then targets[#targets + 1] = cell end
    end)
    return targets
end

function BaseTransmitter:relay(action, wide)
    local root = not wave
    wave = wave or {}

    if not wave[self] then
        wave[self] = true

        for _, cell in ipairs(self:_targets(wide)) do
            if not wave[cell] then action(cell) end
        end
    end
    if root then wave = nil end
end

function BaseTransmitter:rotated(amount, wide)
    self:relay(function(cell) cell:rotate(amount, false, false, wide) end, wide)
end

function BaseTransmitter:flip(key, forced, wide, quiet)
    if quiet or self:guarded("lock") and not forced then return end
    self:relay(function(cell) cell:flip(key, false, wide) end, wide)
end

return BaseTransmitter
