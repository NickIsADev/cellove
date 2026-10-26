local RowScene = require("src/scenes/abstract/RowScene")
local Panel = require("src/ui/Panel")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.options
local layout = constants.rows
local toggle = constants.ui.toggle
local colors = constants.ui.colors

local OptionsScene = setmetatable({}, { __index = RowScene })
OptionsScene.__index = OptionsScene

function OptionsScene.new(data)
    local self = setmetatable({}, OptionsScene)
    self:setup(data, config)
    self.settings = data.settings
    self.texturePacks = data.texturePacks
    self.mods = data.mods
    self.drawers = {
        link = self._drawLink,
        slider = self._drawSlider,
        toggle = self._drawToggle
    }
    return self
end

function OptionsScene:_sliderBounds(index)
    local x, _, width = self.list:bounds(index)
    local font = self.renderer:font(layout.font.text)
    local slider = config.slider
    local labels, values = 0, 0

    for _, row in ipairs(self.rows) do
        labels = math.max(labels, font:getWidth(row.title))
        if row.kind == "slider" then
            values = math.max(values, font:getWidth(row.format(row.min)), font:getWidth(row.format(row.max)))
        end
    end

    local right = x + width - layout.row.pad - values - slider.gap
    local span = math.max(slider.min, right - (x + layout.row.pad + labels + slider.gap))
    return right - span, span
end

function OptionsScene:_sliderValue(index, mouseX)
    local row = self.rows[index]
    local left, span = self:_sliderBounds(index)
    local t = utils.clamp((mouseX - left) / span, 0, 1)
    return row.min + math.floor(t * (row.max - row.min) + 0.5)
end

function OptionsScene:_drag(index, x)
    local row, value = self.rows[index], self:_sliderValue(index, x)

    if row.deferred then
        self.pending = value
    else
        self.settings:set(row.key, value)
    end
end

function OptionsScene:_status(row)
    local status = row.source and self[row.source]:status()
    if not status then return {} end

    local parts = {
        { status.enabled > 0 and string.format(config.link.enabled, status.enabled) or config.link.none, colors.muted }
    }
    if status.failed > 0 then parts[#parts + 1] = { string.format(config.link.failed, status.failed), colors.danger } end
    if status.conflicts > 0 then parts[#parts + 1] = { string.format(config.link.conflicts, status.conflicts), colors.warning } end
    return parts
end

function OptionsScene:_drawLink(index, row, x, y, width, height)
    local hover = self.hover[index]
    local arrow = self.renderer.textures.ui.arrow
    local left = x + width - layout.row.pad - config.link.arrow
    local scale = config.link.arrow / arrow:getWidth()
    local font = self:_drawFrame(index, row, x, y, width, height)

    local cursor = left
    for _, part in ipairs(self:_status(row)) do
        cursor = cursor - config.link.gap - font:getWidth(part[1])
        love.graphics.setColor(utils.fromHex(part[2]))
        love.graphics.print(part[1], cursor, y + (height - font:getHeight()) / 2)
    end

    love.graphics.setColor(utils.fromHex(colors.white, 0.5 + 0.5 * hover))
    love.graphics.draw(arrow, left, y + height / 2, 0, scale, scale, 0, arrow:getHeight() / 2)
end

function OptionsScene:_drawSlider(index, row, x, y, width, height)
    local hover = self.hover[index]
    local value = self.drag == index and self.pending or self.settings:get(row.key)
    local centerY = y + height / 2
    local left, span = self:_sliderBounds(index)
    local t = (value - row.min) / (row.max - row.min)
    local slider = config.slider
    local font = self:_drawFrame(index, row, x, y, width, height)

    Panel.fill(left, centerY - slider.track / 2, span, slider.track, colors.track, 1)
    Panel.fill(left, centerY - slider.track / 2, span * t, slider.track, colors.white, 0.8)
    Panel.fill(left + span * t - slider.handle.width / 2, centerY - slider.handle.height / 2,
        slider.handle.width, slider.handle.height, colors.white, 0.8 + 0.2 * hover)

    local text = row.format(value)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(text, x + width - layout.row.pad - font:getWidth(text), centerY - font:getHeight() / 2)
end

function OptionsScene:_drawToggle(index, row, x, y, width, height)
    local renderer = self.renderer
    local hover = self.hover[index]
    local look = self.settings:get(row.key) and toggle.on or toggle.off
    local texture = renderer.textures.ui[look.texture]
    local scale = toggle.size / texture:getWidth()

    self:_drawFrame(index, row, x, y, width, height)

    love.graphics.setColor(utils.fromHex(colors[look.tint], 0.8 + 0.2 * hover))
    love.graphics.draw(texture, x + width - layout.row.pad - toggle.size, y + (height - toggle.size) / 2, 0, scale, scale)
end

function OptionsScene:_press(index, row, x)
    if row.kind == "toggle" then
        self.settings:set(row.key, not self.settings:get(row.key))
        Audio.play("click")
    elseif row.kind == "slider" then
        local left, span = self:_sliderBounds(index)
        if x >= left - config.slider.handle.width and x <= left + span + config.slider.handle.width then
            self.drag = index
            self:_drag(index, x)
            Audio.play("click")
        end
    elseif row.kind == "link" then
        Audio.play("click")
        self.manager:switch(row.scene, {
            page = row.page,
            back = { scene = "options", data = { page = self.page, back = self.exit } }
        })
    end
end

function OptionsScene:_restore()
    self.settings:reset()
end

function OptionsScene:enter(previous, data)
    self.page = data and data.page or config.main
    self.drag = nil
    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
    self.title.text = config.pages[self.page].title
    self:_setRows(config.pages[self.page].rows)
    RowScene.enter(self, previous, data)
end

function OptionsScene:leave()
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function OptionsScene:keypressed(key)
    local step = config.steps[key]
    local index = step and not self.prompt.active and self.list:rowAt(love.mouse.getPosition())
    local row = index and self.rows[index]

    if row and row.kind == "slider" then
        self.settings:set(row.key, utils.clamp(self.settings:get(row.key) + step, row.min, row.max))
    else
        RowScene.keypressed(self, key)
    end
end

function OptionsScene:mousemoved(x, y)
    RowScene.mousemoved(self, x, y)
    if self.drag then self:_drag(self.drag, x) end
end

function OptionsScene:mousereleased(x, y, button)
    RowScene.mousereleased(self, x, y, button)
    if button ~= 1 or not self.drag then return end

    if self.pending then self.settings:set(self.rows[self.drag].key, self.pending) end
    self.drag, self.pending = nil, nil
end

return OptionsScene
