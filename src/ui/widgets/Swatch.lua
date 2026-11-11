local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")

local config = constants.ui.swatch
local colors = constants.ui.colors

local Swatch = setmetatable({}, { __index = Widget })
Swatch.__index = Swatch

function Swatch.new(data)
    local self = setmetatable({}, Swatch)
    self:setup({
        renderer = data.renderer,
        width = config.size,
        height = data.height
    })
    self.id = data.id
    self.color = colors.white
    self.title = data.title
    self.description = data.description
    return self
end

function Swatch:drawTooltip(tooltip)
    if self:contains(love.mouse.getPosition()) then tooltip:draw(self.title, self.description) end
end

function Swatch:draw()
    local size = config.size * (1 + constants.ui.hover.growth * self.hover)
    local x, y = self.x + (self.width - size) / 2, self.y + (self.height - size) / 2

    local alpha = self.enabled and 1 or constants.ui.disabled

    Panel.fill(x, y, size, size, self.color, alpha)
    Panel.outline(x, y, size, size, self.selected and colors.accent or colors.white, (self.selected and 1 or 0.6) * alpha)
end

return Swatch
