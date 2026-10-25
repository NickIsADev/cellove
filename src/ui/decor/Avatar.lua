local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.avatar
local colors = constants.ui.colors

local Avatar = {}

function Avatar.draw(renderer, icon, name, x, y, size)
    Panel.fill(x, y, size, size, colors.dark, 1)

    if icon then
        local width, height = icon:getDimensions()
        local scale = size / math.max(width, height)

        love.graphics.setColor(utils.fromHex(colors.white))
        love.graphics.draw(icon, x + size / 2, y + size / 2, 0, scale, scale, width / 2, height / 2)
    else
        local font = renderer:font(config.font)
        local letter = name:sub(1, 1):upper()

        love.graphics.setFont(font)
        love.graphics.setColor(utils.fromHex(colors.white, config.alpha))
        love.graphics.print(
            letter,
            math.floor(x + (size - font:getWidth(letter)) / 2),
            math.floor(y + size / 2 - font:getBaseline() * (1 - config.cap / 2))
        )
    end

    Panel.outline(x, y, size, size, colors.border, 1)
end

return Avatar
