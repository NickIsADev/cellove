local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.toast
local colors = constants.ui.colors

local Toast = {}
Toast.__index = Toast

function Toast.new(renderer)
    local self = setmetatable({}, Toast)
    self.renderer = renderer
    self.text = ""
    self.failed = false
    self.time = config.time
    self.timer = 0
    return self
end

function Toast:show(text, failed, time)
    self.text = text
    self.failed = failed or false
    self.time = time or config.time
    self.timer = self.time
end

function Toast:clear()
    self.timer = 0
end

function Toast:update(dt)
    self.timer = math.max(0, self.timer - dt)
end

function Toast:draw(centerY)
    if self.timer <= 0 then return end

    local renderer = self.renderer
    local w = love.graphics.getWidth()
    local font = renderer:font(config.font)
    local previousFont = love.graphics.getFont()

    local entered = utils.clamp((self.time - self.timer) / config.enter, 0, 1)
    local eased = 1 - (1 - entered) ^ 3
    local alpha = math.min(1, self.timer / config.fade) * eased

    local icon = renderer.textures.ui[self.failed and "x" or "checkmark"]
    local iconScale = config.icon / icon:getWidth()
    local tint = self.failed and colors.danger or colors.accent

    local boxHeight = math.max(font:getHeight(), config.icon) + config.pad * 2
    local inset = config.pad * 2 + config.icon + config.gap
    local textWidth = math.min(w - 32 - inset, font:getWidth(self.text))
    local boxWidth = textWidth + inset
    local x = (w - boxWidth) / 2
    local y = centerY - boxHeight / 2 + (1 - eased) * config.slide

    Panel.fill(x + config.shadow, y + config.shadow, boxWidth, boxHeight, 0x000000, 0.4 * alpha)
    Panel.draw(x, y, boxWidth, boxHeight, {
        alpha = 0.95,
        fade = alpha,
        border = tint
    })
    Panel.fill(x, y, boxWidth, boxHeight, tint, 0.1 * alpha)

    love.graphics.setColor(utils.fromHex(tint, alpha))
    love.graphics.draw(icon, x + config.pad, y + (boxHeight - config.icon) / 2, 0, iconScale, iconScale)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    utils.printFitted(self.text, x + config.pad + config.icon + config.gap, y + (boxHeight - font:getHeight()) / 2, textWidth)

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Toast
