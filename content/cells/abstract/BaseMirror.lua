local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local BaseMirror = setmetatable({
    categories = { "forces", "mirrors" },
    subtick = { 0 },
    outputs = { 0, 1, 2, 3 },
    directional = true,
    swaps = {},
    reach = 1,
    span = 0
}, { __index = BaseCell })
BaseMirror.__index = BaseMirror

function BaseMirror:_offset(direction)
    direction = (direction + self.rotation) % 4

    local low = math.floor(direction)
    local first = constants.directions[low]
    if direction == low then return first[1], first[2] end

    local second = constants.directions[(low + 1) % 4]
    return first[1] + second[1], first[2] + second[2]
end

function BaseMirror:_mirrored(ox, oy, dx, dy)
    local cell = self.simulator.grid:get(self.x + ox, self.y + oy)
    return cell and cell.mirrors and cell:mirrors(dx, dy)
end

function BaseMirror:_apply(pair)
    local class = getmetatable(self)
    local ax, ay = self:_offset(pair[1])
    local bx, by = self:_offset(pair[2])

    for lateral = -class.span, class.span do
        for distance = 1, class.reach do
            local fx, fy = ax * distance - ay * lateral, ay * distance + ax * lateral
            local sx, sy = bx * distance - ay * lateral, by * distance + ax * lateral

            if self:_mirrored(fx, fy, ax, ay) or self:_mirrored(sx, sy, bx, by) then break end
            if not self:swap(fx, fy, sx, sy) then break end
        end
    end
end

function BaseMirror:mirrors(dx, dy)
    for _, pair in ipairs(getmetatable(self).swaps) do
        for _, direction in ipairs(pair) do
            local fx, fy = self:_offset(direction)
            if fx == -dx and fy == -dy then return true end
        end
    end
end

function BaseMirror:update(_, direction)
    local class = getmetatable(self)
    local axis = constants.simulator.axes[direction]

    for _, pair in ipairs(class.swaps) do
        if (pair[1] + self.rotation) % 2 == axis then self:_apply(pair) end
    end
end

return BaseMirror
