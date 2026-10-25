local Widget = require("src/ui/abstract/Widget")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.icon
local colors = constants.ui.colors

local IconButton = setmetatable({}, { __index = Widget })
IconButton.__index = IconButton

function IconButton.new(data)
    local self = setmetatable({}, IconButton)
    self:setup({
        renderer = data.renderer,
        width = data.size,
        height = data.size
    })
    self.id = data.id
    self.folder = data.folder or "ui"
    self.texture = data.texture
    self.rotation = data.rotation or 0
    self.spin = data.spin or 0
    self.tint = data.tint or colors.white
    self.alpha = data.alpha or config.alpha
    self.growth = data.growth or constants.ui.hover.growth
    self.glow = data.glow or false
    self.label = data.label
    self.labelSide = data.labelSide or "below"
    self.labelFont = data.labelFont or config.labelFont
    self.labelGap = data.labelGap or config.labelGap
    self.title = data.title
    self.description = data.description
    return self
end

function IconButton:_drawLabel(fade)
    local font = self.renderer:font(self.labelFont)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, (0.5 + 0.5 * self.hover) * fade))
    if self.labelSide == "right" then
        love.graphics.print(self.label, self.x + self.width + self.labelGap, self.y + (self.height - font:getHeight()) / 2)
    else
        local limit = math.max(self.width * 2, font:getWidth(self.label))
        love.graphics.printf(self.label, self.x + (self.width - limit) / 2, self.y + self.height + self.labelGap, limit, "center")
    end
end

function IconButton:place(x, y, size)
    Widget.place(self, x, y, size or self.width, size or self.height)
end

function IconButton:drawTooltip(tooltip)
    if self.title and self:contains(love.mouse.getPosition()) then
        tooltip:draw(self.title, self.description)
    end
end

function IconButton:draw()
    local texture = self.renderer.textures[self.folder][self.texture]
    local tw, th = texture:getDimensions()
    local fade = self.enabled and 1 or constants.ui.disabled
    local scale = self.width / tw * (1 + self.growth * self.hover)
    local cx, cy = self.x + self.width / 2, self.y + self.height / 2
    local previousFont = love.graphics.getFont()

    if self.glow then
        love.graphics.setColor(utils.fromHex(self.tint, config.glow * self.hover))
        love.graphics.draw(texture, cx, cy, self.rotation, scale * 1.25, scale * 1.25, tw / 2, th / 2)
    end

    love.graphics.setColor(utils.fromHex(self.tint, utils.lerp(self.alpha.idle, self.alpha.hover, self.hover) * fade))
    love.graphics.draw(texture, cx, cy, self.rotation + self.spin * self.hover, scale, scale, tw / 2, th / 2)

    if self.label then self:_drawLabel(fade) end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return IconButton
