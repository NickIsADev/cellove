local BaseTool = require("src/editor/tools/abstract/BaseTool")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.brush
local ghost = constants.editor.ghost
local hues = constants.markers.hues
local colors = constants.ui.colors

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

function Brush:_wipe(x, y)
    local editor = self.editor
    local grid, markers = editor.simulator.grid, editor.markers
    local top = grid:top(x, y)

    if top then
        editor:setCell(x, y, nil, top.layer)
    elseif markers:at(x, y) then
        editor:setMarker(x, y)
    elseif markers:placeableAt(x, y) then
        editor:setPlaceable(x, y, false)
    elseif markers:boxAt(x, y) then
        editor:removeArea(markers:boxAt(x, y))
    end
end

function Brush:_paint(gx, gy)
    local editor = self.editor
    local class = editor.selected
    local state = not self.erasing and {
        class = class,
        rotation = editor.targetRotation % 4,
        props = editor.properties:values(class)
    } or nil

    for _, point in ipairs(self.points) do
        local x, y = gx + point[1], gy + point[2]
        if self.erase then
            self:_wipe(x, y)
        elseif class and class.tile then
            editor:setPlaceable(x, y, state and hues[state.props.color])
        else
            editor:setCell(x, y, state)
        end
    end
end

function Brush:_stock(gx, gy)
    local editor = self.editor
    local cell = editor.simulator.grid:get(gx, gy)
    if not (cell and cell.stockable and (not self.erasing or cell:held())) then return false end

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
    elseif id == "erase" then
        self.erase = not self.erase
    elseif id == "shape" then
        self:_set(self.size, self.shape == "square" and "circle" or "square")
    end
end

function Brush:wheel(amount)
    self:_resize(amount > 0 and 1 or -1)
    return true
end

function Brush:profile()
    if not self.erase then return self.editor.selected end
end

function Brush:leave()
    self.erase = false
end

function Brush:reset()
    self:_set(config.default.size, config.default.shape)
    self:leave()
end

function Brush:refresh()
    local look, button = config.shapes[self.shape], self.byId.shape
    button.texture, button.title, button.description = look.texture, look.title, look.description
    self.byId.decrease.enabled = self.size > config.size.min
    self.byId.increase.enabled = self.size < config.size.max
    self.byId.size.text = tostring(self.size)
    self.byId.erase.tint = self.erase and colors.accent or colors.white
end

function Brush:press(gx, gy, button)
    if button == 1 and not (self.erase or self.editor.selected) then return false end

    self.erasing = button == 2 or self.erase
    self.x, self.y = gx, gy
    local class = self.editor.selected
    if self.erase or class and class.tile or not self:_stock(gx, gy) then self:_paint(gx, gy) end
    return true
end

function Brush:move(gx, gy)
    self:_drag(gx, gy)
end

function Brush:draw(gx, gy)
    local editor = self.editor
    local class = editor.selected
    if not gx or not (self.erase or class) then return end

    local props = class and editor.properties:values(class)
    for _, point in ipairs(self.points) do
        local x, y = gx + point[1], gy + point[2]
        if editor.simulator.grid:bounds(x, y) then
            if self.erase then
                editor.renderer:drawBox(x, y, x, y, colors.danger)
            elseif class.tile then
                editor.renderer:drawSlot(x, y, hues[props.color], ghost)
            else
                editor.renderer:drawGhost(class:preview(props), x, y, editor.visualRotation, ghost)
            end
        end
    end
end

return Brush
