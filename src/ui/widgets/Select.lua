local Widget = require("src/ui/abstract/Widget")
local Dropdown = require("src/ui/widgets/Dropdown")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.select
local colors = constants.ui.colors

local Select = setmetatable({}, { __index = Widget })
Select.__index = Select

function Select.new(data)
    local self = setmetatable({}, Select)
    self:setup({ renderer = data.renderer, width = data.width, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.names = data.names
    self.items, self.byValue = {}, {}
    self.extra = 0

    local font = data.renderer:font(config.font)
    for value = data.min, data.max do
        local item = { id = value, title = data.names[value], icon = data.preview and data.preview(value) }
        self.items[#self.items + 1], self.byValue[value] = item, item
        self.extra = math.max(self.extra, font:getWidth(item.title) + config.pad * 2 + (item.icon and config.icon + config.pad or 0) - constants.editor.properties.control)
    end
    self.menu = Dropdown.new({ renderer = data.renderer, items = self.items, onPick = function(item) self:set(item.id) end })
    self:set(data.value)
    return self
end

function Select:get()
    return self.value
end

function Select:set(value)
    self.value = value
    self.menu:select(value)
end

function Select:place(x, y, width)
    Widget.place(self, x, y, width)

    local barX = x + self.labelWidth
    local barWidth = width - self.labelWidth
    local below = y + self.height + config.gap
    local fits = below + self.menu:height() <= love.graphics.getHeight()

    self.menu:place(barX, fits and below or y - config.gap - self.menu:height(), barWidth)
end

function Select:mousepressed(x, y, button)
    if self.menu.shown then return self.menu:mousepressed(x, y) end
    if button ~= 1 or not self:hit(x, y) then return false end

    self.menu:show()
    return true
end

function Select:update(dt)
    Widget.update(self, dt)
    self.menu:update(dt)
end

function Select:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local centerY = self.y + self.height / 2
    local barX = self.x + self.labelWidth
    local barWidth = self.width - self.labelWidth

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * self.hover))
    love.graphics.print(self.label, self.x, centerY - font:getHeight() / 2)

    Panel.fill(barX, self.y, barWidth, self.height, colors.white, config.fill + config.fill * self.hover)
    Panel.outline(barX, self.y, barWidth, self.height, colors.white, config.outline)

    local item, left = self.byValue[self.value], barX + config.pad
    love.graphics.setColor(utils.fromHex(colors.white))
    if item.icon then
        local texture = self.renderer.textures.cells[item.icon]
        love.graphics.draw(texture, left, centerY - config.icon / 2, 0, config.icon / texture:getWidth(), config.icon / texture:getHeight())
        left = left + config.icon + config.pad
    end
    love.graphics.print(item.title, left, centerY - font:getHeight() / 2)

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Select:drawMenu()
    self.menu:draw()
end

return Select
