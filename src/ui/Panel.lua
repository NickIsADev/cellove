local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.panel
local row = constants.ui.list.row
local colors = constants.ui.colors
local heading = config.heading

local Panel = {}

function Panel.fill(x, y, width, height, color, alpha)
    love.graphics.setColor(utils.fromHex(color, alpha))
    love.graphics.rectangle("fill", x, y, width, height)
end

function Panel.outline(x, y, width, height, color, alpha)
    love.graphics.setLineWidth(config.width)
    love.graphics.setColor(utils.fromHex(color, alpha))
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setLineWidth(1)
end

function Panel.dashed(x, y, width, height, color, alpha, phase)
    local dash = config.dash
    local edges = {
        { x, y, x + width, y },
        { x + width, y, x + width, y + height },
        { x + width, y + height, x, y + height },
        { x, y + height, x, y }
    }
    local travelled = phase

    love.graphics.setLineWidth(config.width)
    love.graphics.setColor(utils.fromHex(color, alpha))
    for _, edge in ipairs(edges) do
        local dx, dy = edge[3] - edge[1], edge[4] - edge[2]
        local length = math.abs(dx + dy)
        local from = -(travelled % (dash * 2))

        for start = from, length, dash * 2 do
            local a, b = math.max(start, 0), math.min(start + dash, length)
            if b > a then
                local ux, uy = dx / length, dy / length
                love.graphics.line(edge[1] + ux * a, edge[2] + uy * a, edge[1] + ux * b, edge[2] + uy * b)
            end
        end
        travelled = travelled + length
    end
    love.graphics.setLineWidth(1)
end

function Panel.placeholder(x, y, width, height, fade)
    Panel.fill(x, y, width, height, colors.white, config.hole.fill * fade)
    Panel.dashed(x, y, width, height, colors.white, config.hole.alpha * fade, love.timer.getTime() * config.hole.speed)
end

function Panel.selected(x, y, width, height, fade)
    fade = fade or 1

    Panel.fill(x, y, width, height, colors.white, row.selected * fade)
    Panel.outline(x, y, width, height, colors.white, row.outline * fade)
end

function Panel.draw(x, y, width, height, style)
    style = style or {}
    local fade = style.fade or 1

    Panel.fill(x, y, width, height, style.fill or colors.panel, (style.alpha or config.alpha) * fade)
    Panel.outline(x, y, width, height, style.border or colors.border, (style.borderAlpha or 1) * fade)

    if style.highlight and style.highlight > 0 then
        Panel.outline(x, y, width, height, colors.white, config.highlight * style.highlight)
    end
end

function Panel.headingWidth(font, title, texture)
    return font:getWidth(title) + (texture and font:getHeight() + heading.gap or 0)
end

function Panel.heading(renderer, font, x, y, title, texture)
    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white))

    if texture then
        local icon, size = renderer.textures.cells[texture], font:getHeight()

        love.graphics.draw(icon, x, y + font:getBaseline() * heading.center - size / 2, 0,
            size / icon:getWidth(), size / icon:getHeight())
        x = x + size + heading.gap
    end
    love.graphics.print(title, x, y)
end

return Panel
