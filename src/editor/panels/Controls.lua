local Tooltip = require("src/ui/overlays/Tooltip")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.controls
local colors = constants.ui.colors

local Controls = {}
Controls.__index = Controls

function Controls.new(renderer, simulator, hidden)
    local self = setmetatable({}, Controls)
    self.renderer = renderer
    self.simulator = simulator
    self.hidden = hidden or {}
    self.tooltip = Tooltip.new(renderer)
    return self
end

function Controls:_position(button)
    local step = config.slot + config.pad

    return love.graphics.getWidth() - config.margin - config.slot - button.col * step,
           config.margin + button.row * step
end

function Controls:_visible(button)
    return not self.hidden[button.id] and (not button.needsStart or self.simulator:started())
end

function Controls:_look(button)
    if button.id == "toggle" then return self.simulator.paused and config.play or config.pause end
    return button
end

function Controls:buttonAt(x, y)
    for _, button in ipairs(config.buttons) do
        if self:_visible(button) then
            local bx, by = self:_position(button)
            if utils.inside(x, y, bx, by, config.slot, config.slot) then return button.id end
        end
    end
end

function Controls:draw()
    local renderer = self.renderer
    local hovered = self:buttonAt(love.mouse.getPosition())
    local hoveredLook

    for _, button in ipairs(config.buttons) do
        if self:_visible(button) then
            local look = self:_look(button)
            local bx, by = self:_position(button)

            local tex = renderer.textures[look.folder or "cells"][look.texture]
            local tw, th = tex:getWidth(), tex:getHeight()
            local scale = config.slot / tw

            love.graphics.setColor(utils.fromHex(colors.white, button.id == hovered and 0.75 or 0.5))
            love.graphics.draw(tex, bx + config.slot / 2, by + config.slot / 2, look.rotation, scale, scale, tw / 2, th / 2)

            if button.id == hovered then hoveredLook = look end
        end
    end

    if hoveredLook then
        self.tooltip:draw(hoveredLook.title, hoveredLook.description)
    end

    love.graphics.setColor(utils.fromHex(colors.white))
end

return Controls
