local IconButton = require("src/ui/widgets/IconButton")
local TextField = require("src/ui/widgets/TextField")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.colorPicker
local prompt = constants.prompt
local colors = constants.ui.colors

local function makeButton(renderer, texture, tint, label)
    return IconButton.new({
        renderer = renderer,
        folder = "ui",
        texture = texture,
        size = prompt.button.size,
        tint = tint,
        label = label,
        labelFont = prompt.button.font,
        labelGap = prompt.button.labelGap
    })
end

local function vertex(x, y, r, g, b, a)
    return { x, y, 0, 0, r, g, b, a or 1 }
end

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(renderer)
    local self = setmetatable({}, ColorPicker)
    self.renderer = renderer
    self.active = false
    self.box = {}
    self.hsv = { h = 0, s = 0, v = 1 }

    self.field = TextField.new({ renderer = renderer, limit = 6, filter = "[^%x]" })
    self.confirmButton = makeButton(renderer, "checkmark", colors.accent, prompt.text.confirm)
    self.cancelButton = makeButton(renderer, "x", colors.danger, prompt.text.cancel)

    self.gradient = love.graphics.newMesh({
        vertex(0, 0, 1, 1, 1),
        vertex(1, 0, 1, 1, 1),
        vertex(1, 1, 1, 1, 1),
        vertex(0, 1, 1, 1, 1)
    }, "fan", "dynamic")
    self.shade = love.graphics.newMesh({
        vertex(0, 0, 0, 0, 0, 0),
        vertex(1, 0, 0, 0, 0, 0),
        vertex(1, 1, 0, 0, 0, 1),
        vertex(0, 1, 0, 0, 0, 1)
    }, "fan", "static")

    local stops = {}
    for index = 0, config.stops do
        local r, g, b = utils.fromHsv(index / config.stops, 1, 1)
        stops[#stops + 1] = vertex(0, index / config.stops, r, g, b)
        stops[#stops + 1] = vertex(1, index / config.stops, r, g, b)
    end
    self.spectrum = love.graphics.newMesh(stops, "strip", "static")
    return self
end

function ColorPicker:_layout()
    local w, h = love.graphics.getDimensions()
    local titleFont = self.renderer:font(prompt.font.title)
    local labelFont = self.renderer:font(prompt.button.font)
    local button, box = prompt.button, self.box
    local fieldHeight = constants.ui.field.height
    local buttonsHeight = button.size + button.labelGap + labelFont:getHeight()

    box.inner = config.square + prompt.gap + config.bar
    box.width = box.inner + prompt.pad * 2
    box.height = prompt.pad * 2 + titleFont:getHeight() + prompt.gap * 3 + config.square + fieldHeight + buttonsHeight
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2
    box.squareX = box.x + prompt.pad
    box.squareY = box.y + prompt.pad + titleFont:getHeight() + prompt.gap
    box.barX = box.squareX + config.square + prompt.gap
    box.fieldY = box.squareY + config.square + prompt.gap
    box.buttonY = box.y + box.height - prompt.pad - buttonsHeight

    self.field:place(box.squareX + fieldHeight + prompt.gap, box.fieldY, box.inner - fieldHeight - prompt.gap)

    local left = box.x + (box.width - (button.size * 2 + button.gap)) / 2
    self.cancelButton:place(left, box.buttonY, button.size)
    self.confirmButton:place(left + button.size + button.gap, box.buttonY, button.size)
end

function ColorPicker:_color()
    return utils.toHex(utils.fromHsv(self.hsv.h, self.hsv.s, self.hsv.v))
end

function ColorPicker:_tint()
    local r, g, b = utils.fromHsv(self.hsv.h, 1, 1)

    self.gradient:setVertex(2, vertex(1, 0, r, g, b))
    self.gradient:setVertex(3, vertex(1, 1, r, g, b))
end

function ColorPicker:_pick(x, y)
    local box, hsv = self.box, self.hsv
    local fraction = utils.clamp((y - box.squareY) / config.square, 0, 1)

    if self.dragging == "square" then
        hsv.s = utils.clamp((x - box.squareX) / config.square, 0, 1)
        hsv.v = 1 - fraction
    else
        hsv.h = fraction
    end
    self.field:set(string.format("%06X", self:_color()))
    self:_tint()
end

function ColorPicker:_edit()
    if #self.field.text < 6 then return end

    self.hsv.h, self.hsv.s, self.hsv.v = utils.toHsv(utils.fromHex(tonumber(self.field.text, 16)))
    self:_tint()
end

function ColorPicker:_confirm()
    local color = self:_color()

    self:close()
    self.onConfirm(color)
end

function ColorPicker:open(color, onConfirm)
    self.active = true
    self.onConfirm = onConfirm
    self.field:set(string.format("%06X", color))
    self:_edit()

    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
end

function ColorPicker:close()
    self.active = false
    self.dragging = nil
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function ColorPicker:update(dt)
    if not self.active then return end

    self:_layout()
    self.field:update(dt)
    self.confirmButton:update(dt)
    self.cancelButton:update(dt)
end

function ColorPicker:mousepressed(x, y, button)
    if not self.active then return false end

    self:_layout()
    if button ~= 1 then return true end

    local box = self.box
    if utils.inside(x, y, box.squareX, box.squareY, config.square, config.square) then
        self.dragging = "square"
    elseif utils.inside(x, y, box.barX, box.squareY, config.bar, config.square) then
        self.dragging = "bar"
    elseif self.confirmButton:hit(x, y) then
        self:_confirm()
    elseif self.cancelButton:hit(x, y) then
        self:close()
    end

    if self.dragging then self:_pick(x, y) end
    return true
end

function ColorPicker:mousemoved(x, y)
    if self.dragging then self:_pick(x, y) end
end

function ColorPicker:mousereleased()
    self.dragging = nil
end

function ColorPicker:keypressed(key)
    if not self.active then return false end

    if key == "escape" then
        self:close()
    elseif key == "return" or key == "kpenter" then
        self:_confirm()
    elseif self.field:keypressed(key) then
        self:_edit()
    end
    return true
end

function ColorPicker:textinput(text)
    if self.active and self.field:textinput(text) then self:_edit() end
end

function ColorPicker:draw()
    if not self.active then return end

    self:_layout()
    local box, hsv = self.box, self.hsv
    local w, h = love.graphics.getDimensions()
    local fieldHeight = constants.ui.field.height
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, prompt.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    love.graphics.setFont(self.renderer:font(prompt.font.title))
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(config.title, box.squareX, box.y + prompt.pad)

    love.graphics.draw(self.gradient, box.squareX, box.squareY, 0, config.square, config.square)
    love.graphics.draw(self.shade, box.squareX, box.squareY, 0, config.square, config.square)
    love.graphics.draw(self.spectrum, box.barX, box.squareY, 0, config.bar, config.square)
    Panel.outline(box.squareX, box.squareY, config.square, config.square, colors.border, 1)
    Panel.outline(box.barX, box.squareY, config.bar, config.square, colors.border, 1)

    love.graphics.setColor(utils.fromHex(0x000000))
    love.graphics.circle("line", box.squareX + hsv.s * config.square, box.squareY + (1 - hsv.v) * config.square, config.handle + 1)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.circle("line", box.squareX + hsv.s * config.square, box.squareY + (1 - hsv.v) * config.square, config.handle)
    Panel.outline(box.barX - 2, box.squareY + hsv.h * config.square - config.handle / 2, config.bar + 4, config.handle, colors.white, 1)

    Panel.fill(box.squareX, box.fieldY, fieldHeight, fieldHeight, self:_color(), 1)
    Panel.outline(box.squareX, box.fieldY, fieldHeight, fieldHeight, colors.border, 1)
    self.field:draw()
    self.cancelButton:draw()
    self.confirmButton:draw()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return ColorPicker
