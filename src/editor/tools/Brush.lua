local BaseTool = require("src/editor/tools/abstract/BaseTool")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.brush
local ghost = constants.editor.ghost

local function footprint(size, shape)
    local low, high = -math.floor((size - 1) / 2), math.floor(size / 2)
    local center = (low + high) / 2
    local limit = (size * size - size) / 4

    local points = {}
    for dy = low, high do
        for dx = low, high do
            if shape == "square" or (dx - center) ^ 2 + (dy - center) ^ 2 <= limit then
                points[#points + 1] = { dx, dy }
            end
        end
    end
    return points
end

local Brush = setmetatable({}, { __index = BaseTool })
Brush.__index = Brush

function Brush.new(editor)
    local self = setmetatable({}, Brush)
    self:setup(editor, config.buttons)
    self:reset()
    return self
end

function Brush:_paint(gx, gy)
    local editor = self.editor
    local state = not self.erasing and {
        class = editor.selected,
        rotation = editor.targetRotation % 4,
        props = editor.properties:values(editor.selected)
    } or nil

    for _, point in ipairs(self.points) do
        editor:setCell(gx + point[1], gy + point[2], state)
    end
end

function Brush:_stock(gx, gy)
    local editor = self.editor
    local cell = editor.simulator.grid:get(gx, gy)
    if not (cell and cell.held and (not self.erasing or cell:held())) then return false end

    local props = utils.copy(cell.props)
    props.stored = not self.erasing and {
        class = editor.selected,
        rotation = editor.targetRotation % 4,
        props = editor.properties:values(editor.selected)
    } or nil

    editor:setCell(gx, gy, { class = getmetatable(cell), rotation = cell.rotation, props = props })
    return true
end

function Brush:_set(size, shape)
    self.size = utils.clamp(size, config.size.min, config.size.max)
    self.shape = shape
    self.points = footprint(self.size, self.shape)
end

function Brush:_resize(amount)
    self:_set(self.size + amount, self.shape)
end

function Brush:click(id)
    if id == "decrease" then
        self:_resize(-1)
    elseif id == "increase" then
        self:_resize(1)
    elseif id == "shape" then
        self:_set(self.size, self.shape == "square" and "circle" or "square")
    end
end

function Brush:wheel(amount)
    self:_resize(amount > 0 and 1 or -1)
    return true
end

function Brush:reset()
    self:_set(config.default.size, config.default.shape)
end

function Brush:refresh()
    local look, button = config.shapes[self.shape], self.byId.shape
    button.texture, button.title, button.description = look.texture, look.title, look.description
    self.byId.decrease.enabled = self.size > config.size.min
    self.byId.increase.enabled = self.size < config.size.max
    self.byId.size.text = tostring(self.size)
end

function Brush:press(gx, gy, button)
    if button == 1 and not self.editor.selected then return false end

    self.erasing = button == 2
    self.x, self.y = gx, gy
    if not self:_stock(gx, gy) then self:_paint(gx, gy) end
    return true
end

function Brush:move(gx, gy)
    local dx, dy = gx - self.x, gy - self.y
    local steps = math.max(math.abs(dx), math.abs(dy))

    for i = 1, steps do
        local t = i / steps
        self:_paint(math.floor(self.x + dx * t + 0.5), math.floor(self.y + dy * t + 0.5))
    end
    self.x, self.y = gx, gy
end

function Brush:draw(gx, gy)
    local editor = self.editor
    if not (gx and editor.selected) then return end

    for _, point in ipairs(self.points) do
        local x, y = gx + point[1], gy + point[2]
        if editor.simulator.grid:bounds(x, y) then
            editor.renderer:drawGhost(editor.selected.texture, x, y, editor.visualRotation, ghost)
        end
    end
end

return Brush
