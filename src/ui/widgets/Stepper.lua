local Widget = require("src/ui/abstract/Widget")
local IconButton = require("src/ui/widgets/IconButton")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.stepper
local colors = constants.ui.colors

local Stepper = setmetatable({}, { __index = Widget })
Stepper.__index = Stepper

function Stepper.new(data)
    local self = setmetatable({}, Stepper)
    self:setup({ renderer = data.renderer, width = data.width, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.min, self.max = data.min, data.max
    self.value = utils.clamp(data.value, data.min, data.max)
    self.dragging = false
    self.trackX, self.trackWidth = 0, 0
    self.minus = IconButton.new({
        renderer = data.renderer,
        folder = "ui",
        texture = "subtract",
        size = config.height
    })
    self.plus = IconButton.new({
        renderer = data.renderer,
        folder = "ui",
        texture = "add",
        size = config.height
    })
    return self
end

function Stepper:_fromMouse(mouseX)
    local t = utils.clamp((mouseX - self.trackX) / self.trackWidth, 0, 1)
    self:set(self.min + t * (self.max - self.min))
end

function Stepper:_startHold(direction)
    self:set(self.value + direction)
    self.hold = { direction = direction, timer = config.delay }
    return true
end

function Stepper:_overTrack(x, y)
    local margin = config.handle.width
    return utils.inside(x, y, self.trackX - margin, self.y, self.trackWidth + margin * 2, self.height)
end

function Stepper:get()
    return self.value
end

function Stepper:set(value)
    self.value = utils.clamp(math.floor(value + 0.5), self.min, self.max)
end

function Stepper:place(x, y, width)
    width = width or self.width
    Widget.place(self, x, y, width)

    local size = config.height
    local minusX = x + self.labelWidth
    local plusX = x + width - config.value - config.gap - size

    self.minus:place(minusX, y)
    self.plus:place(plusX, y)
    self.trackX = minusX + size + config.gap
    self.trackWidth = math.max(1, plusX - config.gap - self.trackX)
end

function Stepper:mousepressed(x, y, button)
    if button ~= 1 then return false end

    if self.minus:hit(x, y) then return self:_startHold(-1) end
    if self.plus:hit(x, y) then return self:_startHold(1) end
    if self:_overTrack(x, y) then
        self.dragging = true
        self:_fromMouse(x)
        return true
    end
    return false
end

function Stepper:mousemoved(x)
    if self.dragging then self:_fromMouse(x) end
end

function Stepper:mousereleased()
    self.dragging = false
    self.hold = nil
end

function Stepper:update(dt)
    if self.hold then
        self.hold.timer = self.hold.timer - dt
        while self.hold.timer <= 0 do
            self:set(self.value + self.hold.direction)
            self.hold.timer = self.hold.timer + config.rate
        end
    end

    self.minus.enabled = self.value > self.min
    self.plus.enabled = self.value < self.max
    self.minus:update(dt)
    self.plus:update(dt)
end

function Stepper:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local centerY = self.y + self.height / 2
    local t = (self.value - self.min) / (self.max - self.min)
    local handle = config.handle
    local value = tostring(self.value)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8))
    love.graphics.print(self.label, self.x, centerY - font:getHeight() / 2)

    self.minus:draw()
    self.plus:draw()

    Panel.fill(self.trackX, centerY - config.track / 2, self.trackWidth, config.track, colors.track, 1)
    Panel.fill(self.trackX, centerY - config.track / 2, self.trackWidth * t, config.track, colors.white, 0.8)
    Panel.fill(self.trackX + self.trackWidth * t - handle.width / 2, centerY - handle.height / 2, handle.width, handle.height, colors.white, 1)

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(value, self.x + self.width - config.value + (config.value - font:getWidth(value)) / 2, centerY - font:getHeight() / 2)

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Stepper
