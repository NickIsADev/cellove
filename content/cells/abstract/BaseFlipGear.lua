local BaseGear = require("content/cells/abstract/BaseGear")
local constants = require("src/constants")

local flip = constants.flip

local function covers(faces, rotation, directions)
    for _, offset in ipairs(faces) do
        if not directions[(rotation + offset) % 4] then return false end
    end
    return true
end

local BaseFlipGear = setmetatable({
    subtick = { "flipGear" },
    sweep = { x = 1, y = -1 },
    axis = "straight"
}, { __index = BaseGear })
BaseFlipGear.__index = BaseFlipGear

function BaseFlipGear:_key()
    return (self.rotation * 2 + flip.shift[self.axis]) % 4
end

function BaseFlipGear:_swaps(ring, key)
    local matrix = flip.reflections[key]
    local swaps = {}

    for _, point in ipairs(ring) do
        local dx, dy = point[1] - self.x, point[2] - self.y
        local mx = matrix[1] * dx + matrix[2] * dy
        local my = matrix[3] * dx + matrix[4] * dy
        if dy * 3 + dx < my * 3 + mx then swaps[#swaps + 1] = { point[1], point[2], self.x + mx, self.y + my } end
    end
    return swaps
end

function BaseFlipGear:_reflect(class, rotation, key)
    local mirrored = {}
    for _, offset in ipairs(class.faces or class.outputs) do
        mirrored[(key - rotation - offset) % 4] = true
    end

    class = class.flipped or class
    local faces = class.faces or class.outputs
    if covers(faces, rotation, mirrored) then return class, rotation end
    for turn = 0, 3 do
        local candidate = (key - rotation + turn) % 4
        if covers(faces, candidate, mirrored) then return class, candidate end
    end
    return class, (key - rotation) % 4
end

function BaseFlipGear:_replace(cell, class)
    local grid = self.simulator.grid
    grid:set(cell.x, cell.y)
    setmetatable(cell, class)
    grid:set(cell.x, cell.y, cell)
end

function BaseFlipGear:_flip(ring, key)
    local grid = self.simulator.grid

    for _, point in ipairs(ring) do
        local cell = grid:get(point[1], point[2])
        if cell then
            local held = cell.props.stored
            local class, rotation = self:_reflect(getmetatable(cell), cell.rotation, key)
            cell:rotate(rotation - cell.rotation)
            if class ~= getmetatable(cell) then self:_replace(cell, class) end

            if held and held.class then
                local content, turned = self:_reflect(held.class, held.rotation, key)
                cell.props.stored = { class = content, rotation = turned, props = held.props }
            end
        end
    end
end

function BaseFlipGear:update()
    local ring = self:_ring(1)
    local key = self:_key()
    if self:_jammed(ring) or not self.simulator.movement:exchange(self:_swaps(ring, key)) then return end
    if not self.cog then self:_flip(ring, key) end
end

return BaseFlipGear
