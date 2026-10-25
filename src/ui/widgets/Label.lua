local Widget = require("src/ui/abstract/Widget")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.label
local colors = constants.ui.colors

local Label = setmetatable({}, { __index = Widget })
Label.__index = Label

function Label.new(data)
    local self = setmetatable({}, Label)
    self:setup({
        renderer = data.renderer,
        width = data.width,
        height = data.height
    })
    self.id = data.id
    self.text = data.text or ""
    self.enabled = false
    return self
end

function Label:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local y = self.y + (self.height - font:getHeight()) / 2

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(0x000000, config.shadow.alpha))
    love.graphics.printf(self.text, self.x + config.shadow.offset, y + config.shadow.offset, self.width, "center")
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.printf(self.text, self.x, y, self.width, "center")

    love.graphics.setFont(previousFont)
end

return Label
