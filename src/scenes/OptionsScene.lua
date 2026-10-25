local ScrollingBackground = require("src/ui/decor/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollView = require("src/ui/widgets/ScrollView")
local Title = require("src/ui/decor/Title")
local Panel = require("src/ui/Panel")
local Prompt = require("src/ui/overlays/Prompt")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.options
local toggle = constants.ui.toggle
local colors = constants.ui.colors

local OptionsScene = {}
OptionsScene.__index = OptionsScene

function OptionsScene.new(data)
    local self = setmetatable({}, OptionsScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.settings = data.settings
    self.texturePacks = data.texturePacks
    self.mods = data.mods
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, config.title)
    self.tooltip = Tooltip.new(data.renderer)
    self.prompt = Prompt.new(data.renderer)
    self.reset = IconButton.new({
        renderer = data.renderer,
        folder = "cells",
        texture = config.reset.texture,
        size = config.reset.size,
        title = config.reset.title,
        description = config.reset.description
    })

    self.list = ScrollView.new({
        renderer = data.renderer,
        gap = config.row.gap,
        drawRow = function(...) self:_drawRow(...) end
    })
    self.list:setItems(config.rows)
    self.drawers = {
        link = self._drawLink,
        slider = self._drawSlider,
        toggle = self._drawToggle
    }

    self.hover = {}
    for index = 1, #config.rows do
        self.hover[index] = 0
    end
    return self
end

function OptionsScene:_layout()
    local w, h = love.graphics.getDimensions()
    local width = math.min(config.row.width, w - config.row.margin * 2)
    local top = h * config.top.ratio

    self.list:place((w - width) / 2, top, width, h - config.row.bottom - top)
end

function OptionsScene:_placeReset()
    self.reset:place(love.graphics.getWidth() - config.reset.margin - config.reset.size, config.reset.margin)
end

function OptionsScene:_requestReset()
    local dialog = config.reset.prompt

    self.prompt:open({
        title = dialog.title,
        message = dialog.message,
        confirm = dialog.confirm,
        onConfirm = function() self.settings:reset() end
    })
end

function OptionsScene:_sliderLeft(index)
    local x, _, width = self.list:bounds(index)
    return x + width - config.row.pad - config.slider.value - config.slider.gap - config.slider.width
end

function OptionsScene:_sliderValue(index, mouseX)
    local row = config.rows[index]
    local t = utils.clamp((mouseX - self:_sliderLeft(index)) / config.slider.width, 0, 1)
    return row.min + math.floor(t * (row.max - row.min) + 0.5)
end

function OptionsScene:_drag(index, x)
    local row, value = config.rows[index], self:_sliderValue(index, x)

    if row.deferred then
        self.pending = value
    else
        self.settings:set(row.key, value)
    end
end

function OptionsScene:_drawPanel(index, x, y, width, height)
    Panel.draw(x, y, width, height, { highlight = self.hover[index] })
end

function OptionsScene:_drawLink(index, row, x, y, width, height)
    local hover = self.hover[index]
    local font = self.renderer:font(config.font.text)
    local arrow = self.renderer.textures.ui.arrow
    local status = self[row.source]:status()
    local left = x + width - config.row.pad - config.link.arrow
    local scale = config.link.arrow / arrow:getWidth()
    local textY = y + (height - font:getHeight()) / 2

    local parts = {
        { status.enabled > 0 and string.format(config.link.enabled, status.enabled) or config.link.none, colors.muted }
    }
    if status.failed > 0 then parts[#parts + 1] = { string.format(config.link.failed, status.failed), colors.danger } end
    if status.conflicts > 0 then parts[#parts + 1] = { string.format(config.link.conflicts, status.conflicts), colors.warning } end

    self:_drawPanel(index, x, y, width, height)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * hover))
    love.graphics.print(row.title, x + config.row.pad, textY)

    local cursor = left
    for _, part in ipairs(parts) do
        cursor = cursor - config.link.gap - font:getWidth(part[1])
        love.graphics.setColor(utils.fromHex(part[2]))
        love.graphics.print(part[1], cursor, textY)
    end

    love.graphics.setColor(utils.fromHex(colors.white, 0.5 + 0.5 * hover))
    love.graphics.draw(arrow, left, y + height / 2, 0, scale, scale, 0, arrow:getHeight() / 2)
end

function OptionsScene:_drawTooltip()
    local index = self.list:rowAt(love.mouse.getPosition())
    local row = index and config.rows[index]
    if row then self.tooltip:draw(row.title, row.description) end
end

function OptionsScene:_drawSlider(index, row, x, y, width, height)
    local renderer = self.renderer
    local hover = self.hover[index]
    local value = self.drag == index and self.pending or self.settings:get(row.key)
    local font = renderer:font(config.font.text)
    local centerY = y + height / 2
    local left = self:_sliderLeft(index)
    local t = (value - row.min) / (row.max - row.min)
    local slider = config.slider

    self:_drawPanel(index, x, y, width, height)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * hover))
    love.graphics.print(row.title, x + config.row.pad, centerY - font:getHeight() / 2)

    Panel.fill(left, centerY - slider.track / 2, slider.width, slider.track, colors.track, 1)
    Panel.fill(left, centerY - slider.track / 2, slider.width * t, slider.track, colors.white, 0.8)
    Panel.fill(left + slider.width * t - slider.handle.width / 2, centerY - slider.handle.height / 2,
        slider.handle.width, slider.handle.height, colors.white, 0.8 + 0.2 * hover)

    local text = row.format(value)
    local textWidth = font:getWidth(text)
    local scale = math.min(1, slider.value / textWidth)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(text, x + width - config.row.pad, centerY, 0, scale, scale, textWidth, font:getHeight() / 2)
end

function OptionsScene:_drawToggle(index, row, x, y, width, height)
    local renderer = self.renderer
    local hover = self.hover[index]
    local value = self.settings:get(row.key)
    local font = renderer:font(config.font.text)
    local look = value and toggle.on or toggle.off
    local texture = renderer.textures.ui[look.texture]
    local scale = toggle.size / texture:getWidth()

    self:_drawPanel(index, x, y, width, height)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * hover))
    love.graphics.print(row.title, x + config.row.pad, y + (height - font:getHeight()) / 2)
    love.graphics.setColor(utils.fromHex(colors[look.tint], 0.8 + 0.2 * hover))
    love.graphics.draw(texture, x + width - config.row.pad - toggle.size, y + (height - toggle.size) / 2, 0, scale, scale)
end

function OptionsScene:_drawRow(index, row, ...)
    self.drawers[row.kind](self, index, row, ...)
end

function OptionsScene:enter(_, data)
    self.exit = data and data.back or { scene = "menu" }
    self.drag = nil
    self.list:resetScroll()
    self:_layout()
end

function OptionsScene:update(dt)
    self:_layout()
    self.background:update(dt)

    local mx, my = love.mouse.getPosition()
    local hoveredRow = self.drag or not self.prompt.active and self.list:rowAt(mx, my)
    local ease = math.min(1, constants.ui.hover.speed * dt)

    for index = 1, #config.rows do
        local target = index == hoveredRow and 1 or 0
        self.hover[index] = utils.lerp(self.hover[index], target, ease)
    end

    self.back:update(dt)
    self:_placeReset()
    self.reset:update(dt)
    self.prompt:update(dt)
end

function OptionsScene:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) then return end
    if button ~= 1 then return end

    if self.back:hit(x, y) then return self.manager:switch(self.exit.scene, self.exit.data) end

    if self.reset:hit(x, y) then return self:_requestReset() end

    if self.list:mousepressed(x, y, button) then return end

    local index = self.list:rowAt(x, y)
    if not index then return end

    local row = config.rows[index]
    if row.kind == "toggle" then
        self.settings:set(row.key, not self.settings:get(row.key))
        Audio.play("click")
    elseif row.kind == "slider" then
        local left = self:_sliderLeft(index)
        if x >= left - config.slider.handle.width and x <= left + config.slider.width + config.slider.handle.width then
            self.drag = index
            self:_drag(index, x)
            Audio.play("click")
        end
    elseif row.kind == "link" then
        Audio.play("click")
        self.manager:switch(row.scene, { back = { scene = "options", data = { back = self.exit } } })
    end
end

function OptionsScene:mousemoved(x, y)
    self.list:mousemoved(x, y)
    if self.drag then self:_drag(self.drag, x) end
end

function OptionsScene:wheelmoved(_, y)
    if not self.prompt.active then self.list:wheelmoved(y) end
end

function OptionsScene:mousereleased(_, _, button)
    if button ~= 1 then return end

    self.list:mousereleased()
    if self.drag and self.pending then
        self.settings:set(config.rows[self.drag].key, self.pending)
    end
    self.drag, self.pending = nil, nil
end

function OptionsScene:keypressed(key)
    if self.prompt:keypressed(key) then return end

    if key == "escape" then
        self.manager:switch(self.exit.scene, self.exit.data)
    end
end

function OptionsScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    self.list:draw()
    self.back:draw()
    self.reset:draw()
    self.prompt:draw()

    if not self.prompt.active then
        self:_drawTooltip()
        self.reset:drawTooltip(self.tooltip)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return OptionsScene
