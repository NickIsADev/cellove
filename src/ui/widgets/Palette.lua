local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.palette
local colors = constants.ui.colors

local Palette = setmetatable({}, { __index = Widget })
Palette.__index = Palette

function Palette.new(data)
    local self = setmetatable({}, Palette)
    self:setup({ renderer = data.renderer, width = data.width, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.swatches = data.swatches
    self.value = utils.clamp(data.value, 1, #data.swatches)
    self.size = config.size
    return self
end

function Palette:_cell(index)
    return self.x + self.labelWidth + (index - 1) * (self.size + config.gap), self.y + (self.height - self.size) / 2
end

function Palette:get()
    return self.value
end

function Palette:set(value)
    self.value = utils.clamp(value, 1, #self.swatches)
end

function Palette:place(x, y, width)
    Widget.place(self, x, y, width)
    local count = #self.swatches
    self.size = math.min(config.size, (self.width - self.labelWidth - config.gap * (count - 1)) / count)
end

function Palette:mousepressed(x, y, button)
    if button ~= 1 then return false end

    for index = 1, #self.swatches do
        local cx, cy = self:_cell(index)
        if utils.inside(x, y, cx, cy, self.size, self.size) then
            self.value = index
            return self:hit(x, y)
        end
    end
    return false
end

function Palette:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local mx, my = love.mouse.getPosition()

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8))
    love.graphics.print(self.label, self.x, self.y + (self.height - font:getHeight()) / 2)

    for index, color in ipairs(self.swatches) do
        local x, y = self:_cell(index)
        local selected = index == self.value
        local grow = (selected or utils.inside(mx, my, x, y, self.size, self.size)) and config.grow or 0
        local size = self.size + grow

        x, y = x - grow / 2, y - grow / 2
        Panel.fill(x, y, size, size, color, 1)
        Panel.outline(x, y, size, size, selected and colors.accent or colors.white, selected and 1 or 0.4)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Palette
