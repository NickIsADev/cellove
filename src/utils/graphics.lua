local fromHex = require("src/utils/color").fromHex

local graphics = {}

function graphics.printFitted(text, x, y, width)
    local font = love.graphics.getFont()
    local scale = math.min(1, width / font:getWidth(text))
    love.graphics.print(text, x, y + (1 - scale) * font:getHeight() / 2, 0, scale, scale)
end

function graphics.drawShadowed(draw, offset, alpha, hex, fade)
    fade = fade or 1

    love.graphics.setColor(fromHex(0x000000, alpha * fade))
    draw(offset, offset)
    love.graphics.setColor(fromHex(hex or 0xFFFFFF, fade))
    draw(0, 0)
end

return graphics
