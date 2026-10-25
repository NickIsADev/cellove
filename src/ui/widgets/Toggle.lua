local Widget = require("src/ui/abstract/Widget")
local IconButton = require("src/ui/widgets/IconButton")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.toggle
local colors = constants.ui.colors

local Toggle = setmetatable({}, { __index = Widget })
Toggle.__index = Toggle

function Toggle.new(data)
    local self = setmetatable({}, Toggle)
    self:setup({ renderer = data.renderer, width = data.width or config.label + config.size, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.icon = IconButton.new({ renderer = data.renderer, folder = "ui", size = config.size })
    self:set(data.value)
    return self
end

function Toggle:get()
    return self.value
end

function Toggle:set(value)
    local look = value and config.on or config.off

    self.value = value
    self.icon.texture, self.icon.tint = look.texture, colors[look.tint]
end

function Toggle:place(x, y, width)
    Widget.place(self, x, y, width)
    self.icon:place(x + self.labelWidth, y + (self.height - config.size) / 2)
end

function Toggle:mousepressed(x, y, button)
    if button ~= 1 or not self:hit(x, y) then return false end

    self:set(not self.value)
    return true
end

function Toggle:update(dt)
    Widget.update(self, dt)
    self.icon:update(dt)
end

function Toggle:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * self.hover))
    love.graphics.print(self.label, self.x, self.y + (self.height - font:getHeight()) / 2)
    self.icon:draw()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Toggle
