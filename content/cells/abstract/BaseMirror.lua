local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local function straight(pair)
    return (pair[2] - pair[1]) % 4 == 2
end

local BaseMirror = setmetatable({
    categories = { "mirrors" },
    subtick = { 4 },
    outputs = { 0, 1, 2, 3 },
    directional = true,
    sweep = {
        [3] = {
            [0] = { x = 1, y = -1, columns = true },
            [1] = { x = 1, y = -1 },
            [2] = { x = 1, y = -1 },
            [3] = { x = 1, y = 1 }
        },
        [2] = {
            [0] = { x = 1, y = -1, columns = true },
            [1] = { x = 1, y = -1, columns = true }
        },
        [4] = {
            [0] = { x = 1, y = -1 },
            [1] = { x = -1, y = -1 },
            [2] = { x = -1, y = 1 },
            [3] = { x = 1, y = 1 }
        }
    },
    swaps = {},
    reach = 1,
    span = 0
}, { __index = BaseCell })
BaseMirror.__index = BaseMirror

function BaseMirror:setup()
    local seen, faces = {}, {}
    for _, pair in ipairs(self.swaps) do
        for _, direction in ipairs(pair) do
            if not seen[direction] then
                seen[direction] = true
                faces[#faces + 1] = direction
            end
        end
    end
    self.faces = faces
end

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
    local ax, ay = self:_offset(pair[1])
    local bx, by = self:_offset(pair[2])

    if not straight(pair) or (pair[1] + self.rotation) % 4 >= 2 then
        ax, ay, bx, by = bx, by, ax, ay
    end

    for lateral = -self.span, self.span do
        for distance = 1, self.reach do
            local fx, fy = ax * distance - ay * lateral, ay * distance + ax * lateral
            local sx, sy = bx * distance - ay * lateral, by * distance + ax * lateral

            if self:_mirrored(fx, fy, ax, ay) or self:_mirrored(sx, sy, bx, by) then break end
            if not self:swap(fx, fy, sx, sy, { bx, by, ax, ay }) then break end
        end
    end
end

function BaseMirror:mirrors(dx, dy)
    for _, pair in ipairs(self.swaps) do
        for _, direction in ipairs(pair) do
            local fx, fy = self:_offset(direction)
            if fx == -dx and fy == -dy then return true end
        end
    end
end

function BaseMirror:update(subtick, direction)
    local first, last = self.subtick[1], self.subtick[#self.subtick]
    local axis = constants.simulator.axes[direction]
    local corner = constants.simulator.corners[direction]

    for _, pair in ipairs(self.swaps) do
        if straight(pair) then
            if subtick == first and (pair[1] + self.rotation) % 2 == axis then self:_apply(pair) end
        elseif subtick == last and (pair[1] + 0.5 + self.rotation) % 4 == corner then
            self:_apply(pair)
        end
    end
end

return BaseMirror
