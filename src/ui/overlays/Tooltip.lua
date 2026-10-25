local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.tooltip
local colors = constants.ui.colors

local Tooltip = {}
Tooltip.__index = Tooltip

function Tooltip.new(renderer)
    local self = setmetatable({}, Tooltip)
    self.renderer = renderer
    return self
end

function Tooltip:_measure(title, description)
    local titleFont = self.renderer:font(config.font.title)
    local descFont = self.renderer:font(config.font.description)

    local textW, descH = titleFont:getWidth(title), 0
    if description ~= "" then
        local w, lines = descFont:getWrap(description, config.width)
        textW = math.max(textW, w)
        descH = #lines * descFont:getHeight() + config.gap
    end

    return textW, titleFont:getHeight() + descH + config.pad * 2
end

function Tooltip:draw(title, description)
    description = description or ""

    local renderer = self.renderer
    local previousFont = love.graphics.getFont()
    local titleFont = renderer:font(config.font.title)
    local descFont = renderer:font(config.font.description)

    local textW, boxH = self:_measure(title, description)
    local boxW = textW + config.pad * 2

    local mx, my = love.mouse.getPosition()
    local w, h = love.graphics.getDimensions()
    local bx, by = mx + config.offset, my + config.offset

    if bx + boxW > w then bx = mx - config.offset - boxW end
    if by + boxH > h then by = my - config.offset - boxH end
    bx = math.max(0, bx)
    by = math.max(0, by)

    Panel.draw(bx, by, boxW, boxH, { alpha = 1 })

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.setFont(titleFont)
    love.graphics.print(title, bx + config.pad, by + config.pad)

    if description ~= "" then
        love.graphics.setColor(utils.fromHex(colors.white, 0.8))
        love.graphics.setFont(descFont)
        love.graphics.printf(description, bx + config.pad, by + config.pad + titleFont:getHeight() + config.gap, textW)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Tooltip
