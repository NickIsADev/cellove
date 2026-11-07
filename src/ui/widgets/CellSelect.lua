local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.cellSelect
local colors = constants.ui.colors

local CellSelect = setmetatable({}, { __index = Widget })
CellSelect.__index = CellSelect

function CellSelect.new(data)
    local self = setmetatable({}, CellSelect)
    self:setup({ renderer = data.renderer, width = data.width, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.options = data.options
    self.picker = data.picker
    self.value = data.value
    return self
end

function CellSelect:get()
    return self.value
end

function CellSelect:mousepressed(x, y, button)
    if button ~= 1 or not self:hit(x, y) then return false end

    self.picker:open({
        classes = self.options,
        current = self.value,
        onPick = function(class) self.value = class end
    })
    return true
end

function CellSelect:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local texture = self.renderer.textures.cells[self.value.texture]
    local centerY = self.y + self.height / 2
    local barX = self.x + self.labelWidth
    local barWidth = self.width - self.labelWidth

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * self.hover))
    love.graphics.print(self.label, self.x, centerY - font:getHeight() / 2)

    Panel.fill(barX, self.y, barWidth, self.height, colors.white, config.fill + config.fill * self.hover)
    Panel.outline(barX, self.y, barWidth, self.height, colors.white, config.outline)

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(texture, barX + config.pad, centerY - config.icon / 2, 0, config.icon / texture:getWidth(), config.icon / texture:getHeight())
    love.graphics.print(self.value.title, barX + config.pad * 2 + config.icon, centerY - font:getHeight() / 2)

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return CellSelect
