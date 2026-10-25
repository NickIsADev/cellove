local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.button
local colors = constants.ui.colors

local Button = setmetatable({}, { __index = Widget })
Button.__index = Button

function Button.new(data)
    local self = setmetatable({}, Button)
    self:setup({
        renderer = data.renderer,
        width = data.width,
        height = config.height
    })
    self.id = data.id
    self.label = data.label
    self.primary = data.primary or false
    return self
end

function Button:draw()
    local font = self.renderer:font(config.font)
    local fade = self.enabled and 1 or constants.ui.disabled

    Panel.draw(self.x, self.y, self.width, self.height, {
        border = self.primary and colors.accent or colors.border,
        highlight = self.hover,
        fade = fade
    })

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, (0.8 + 0.2 * self.hover) * fade))
    love.graphics.print(self.label, self.x + (self.width - font:getWidth(self.label)) / 2, self.y + (self.height - font:getHeight()) / 2)
end

return Button
