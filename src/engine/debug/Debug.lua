local Panel = require("src/ui/Panel")
local Audio = require("src/engine/audio/Audio")
local Display = require("src/engine/graphics/Display")
local World = require("src/engine/debug/World")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.debug
local text = config.text
local colors = constants.ui.colors

local function tint(button)
    return config.colors.buttons[button] or colors.white
end

local function layoutKeys(font)
    local key = config.input.key
    local caps, width = {}, 0

    for row, list in ipairs(config.keys) do
        local x = 0
        for _, cap in ipairs(list) do
            local size = math.max(key.size, font:getWidth(cap.label) + key.pad * 2)
            caps[#caps + 1] = {
                label = cap.label,
                keys = cap.keys,
                x = x,
                y = (row - 1) * (key.size + key.gap),
                width = size
            }
            x = x + size + key.gap
        end
        width = math.max(width, x - key.gap)
    end
    return caps, width, #config.keys * (key.size + key.gap) - key.gap
end

local Debug = {}
Debug.__index = Debug

function Debug.new(data)
    local self = setmetatable({}, Debug)
    self.renderer = data.renderer
    self.settings = data.settings
    self.world = World.new({ renderer = data.renderer })
    self.enabled = false
    self.timer = config.interval
    self.frames = {}
    self.lines = {}
    self.clicks = {}
    self.drags = {}
    self.log = {}
    self.wheel = { direction = 0, age = math.huge }

    data.settings:listen("debug", function(enabled) self.enabled = enabled end)
    return self
end

function Debug:_log(message)
    table.insert(self.log, 1, { text = message, age = 0 })
    self.log[config.log.count + 1] = nil
end

function Debug:_keypressed(key, _, repeated)
    if key == config.key then return self.settings:set("debug", not self.enabled) end
    if not repeated then self:_log(string.format(text.key, key)) end
end

function Debug:_mousepressed(_, _, button)
    local x, y = love.mouse.getPosition()

    self.clicks[#self.clicks + 1] = {
        x = x,
        y = y,
        button = button,
        age = 0
    }
    self.drags[button] = { x = x, y = y }
    self:_log(string.format(text.click, button, x, y))
end

function Debug:_wheelmoved(_, y)
    if y == 0 then return end

    self.wheel.direction, self.wheel.age = y > 0 and 1 or -1, 0
    self:_log(string.format(text.wheel, y))
end

function Debug:_textinput(input)
    self:_log(string.format(text.input, input))
end

function Debug:_collect(manager)
    local stats, audio = love.graphics.getStats(), Audio.stats()
    local w, h = Display.size()
    local uiW, uiH = love.graphics.getDimensions()
    local settings = self.settings

    local total, worst = 0, 0
    for _, frame in ipairs(self.frames) do
        total = total + frame
        worst = math.max(worst, frame)
    end

    local scene = string.format(text.scene, manager.name, manager.fade)
    if manager.pending then scene = string.format(text.pending, manager.name, manager.pending.name, manager.fade) end

    self.lines = {
        string.format(text.fps, love.timer.getFPS(), total / math.max(1, #self.frames) * 1000, worst * 1000),
        string.format(text.memory, collectgarbage("count") / 1024),
        string.format(text.draw, stats.drawcalls, stats.drawcallsbatched, stats.canvasswitches),
        string.format(text.gpu, stats.texturememory / 1048576, stats.images, stats.canvases, stats.fonts),
        string.format(text.window, w, h, uiW, uiH, settings:get("uiScale")),
        scene,
        string.format(text.music, audio.track and audio.track:match("[^/]+$") or text.none, audio.index, audio.count, audio.time, audio.duration),
        string.format(text.sound, audio.sources, settings:get("musicVolume"), settings:get("sfxVolume"), settings:get("musicSpeed"))
    }

    local current = manager.current
    if not (current and current.debugInfo) then return end

    for _, line in ipairs(current:debugInfo()) do
        self.lines[#self.lines + 1] = line
    end
end

function Debug:_drawCrosshair()
    local w, h = love.graphics.getDimensions()
    local x, y = love.mouse.getPosition()
    local font = self.renderer:font(config.font)
    local label = string.format(text.mouse, x, y)
    local labelX = math.min(x + config.cursor.offset, w - font:getWidth(label))
    local labelY = math.min(y + config.cursor.offset, h - font:getHeight())

    love.graphics.setColor(utils.fromHex(colors.white, config.cursor.alpha))
    love.graphics.line(0, y, w, y)
    love.graphics.line(x, 0, x, h)

    love.graphics.setFont(font)
    utils.drawShadowed(function(dx, dy) love.graphics.print(label, labelX + dx, labelY + dy) end, 1, 0.6)
end

function Debug:_drawClicks()
    local ripple = config.ripple

    love.graphics.setLineWidth(ripple.width)
    for _, click in ipairs(self.clicks) do
        local t = click.age / ripple.time

        love.graphics.setColor(utils.fromHex(tint(click.button), 1 - t))
        love.graphics.circle("line", click.x, click.y, ripple.radius * t)
    end
    love.graphics.setLineWidth(1)
end

function Debug:_drawDrags()
    local x, y = love.mouse.getPosition()

    love.graphics.setLineWidth(config.drag.width)
    for button, origin in pairs(self.drags) do
        if love.mouse.isDown(button) then
            love.graphics.setColor(utils.fromHex(tint(button), config.drag.alpha))
            love.graphics.line(origin.x, origin.y, x, y)
            love.graphics.circle("fill", origin.x, origin.y, config.drag.dot)
        else
            self.drags[button] = nil
        end
    end
    love.graphics.setLineWidth(1)
end

function Debug:_drawFrames(x, y, width)
    local graph = config.frames
    local warn = y + graph.height * (1 - graph.warn / graph.limit)

    Panel.fill(x, y, width, graph.height, colors.dark, 1)
    for index, frame in ipairs(self.frames) do
        local height = math.min(1, frame / graph.limit) * graph.height
        local color = (frame > graph.bad and colors.danger) or (frame > graph.warn and config.colors.warn) or colors.accent

        Panel.fill(x + (index - 1) * graph.bar, y + graph.height - height, graph.bar, height, color, 1)
    end
    Panel.fill(x, warn, width, 1, colors.white, 0.3)
end

function Debug:_drawPanel()
    local graph = config.frames
    local font = self.renderer:font(config.font)
    local x, y, pad = config.margin, config.top, config.pad

    local width = graph.count * graph.bar
    for _, line in ipairs(self.lines) do
        width = math.max(width, font:getWidth(line))
    end

    local textHeight = #self.lines * font:getHeight()
    Panel.draw(x, y, width + pad * 2, textHeight + graph.gap + graph.height + pad * 2, { alpha = config.alpha })

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white))
    for index, line in ipairs(self.lines) do
        love.graphics.print(line, x + pad, y + pad + (index - 1) * font:getHeight())
    end
    self:_drawFrames(x + pad, y + pad + textHeight + graph.gap, width)
end

function Debug:_drawMouse(x, y)
    local mouse = config.input.mouse
    local side = (mouse.width - mouse.wheel) / 2
    local wheelX = x + side
    local fade = 1 - math.min(1, self.wheel.age / mouse.flash)

    Panel.draw(x, y, mouse.width, mouse.height, { alpha = config.alpha })
    if love.mouse.isDown(1) then Panel.fill(x, y, side, mouse.split, tint(1), 1) end
    if love.mouse.isDown(2) then Panel.fill(wheelX + mouse.wheel, y, side, mouse.split, tint(2), 1) end
    if love.mouse.isDown(3) then Panel.fill(wheelX, y, mouse.wheel, mouse.split, tint(3), 1) end

    if fade > 0 then
        local cx, cy, size = wheelX + mouse.wheel / 2, y + mouse.split / 2, mouse.wheel / 2 - 2
        local direction = self.wheel.direction

        Panel.fill(wheelX, y, mouse.wheel, mouse.split, colors.white, fade)
        love.graphics.setColor(utils.fromHex(colors.dark, fade))
        love.graphics.polygon("fill", cx, cy - size * direction, cx - size, cy + size * direction, cx + size, cy + size * direction)
    end

    love.graphics.setColor(utils.fromHex(colors.border))
    love.graphics.line(wheelX, y, wheelX, y + mouse.split)
    love.graphics.line(wheelX + mouse.wheel, y, wheelX + mouse.wheel, y + mouse.split)
    love.graphics.line(x, y + mouse.split, x + mouse.width, y + mouse.split)
end

function Debug:_drawInput()
    local w, h = love.graphics.getDimensions()
    local input, key = config.input, config.input.key
    local font = self.renderer:font(config.font)
    local caps, width, height = layoutKeys(font)
    local x, y = w - input.right - width, h - input.bottom - height

    love.graphics.setFont(font)
    for _, cap in ipairs(caps) do
        local down = love.keyboard.isDown(unpack(cap.keys))
        local capX, capY = x + cap.x, y + cap.y

        Panel.draw(capX, capY, cap.width, key.size, {
            fill = down and colors.accent or colors.panel,
            alpha = down and 1 or config.alpha
        })
        love.graphics.setColor(utils.fromHex(down and colors.dark or colors.white))
        love.graphics.print(cap.label, capX + (cap.width - font:getWidth(cap.label)) / 2, capY + (key.size - font:getHeight()) / 2)
    end
    self:_drawMouse(x - input.gap - input.mouse.width, y)

    local lineHeight = font:getHeight() + config.log.gap
    for index, entry in ipairs(self.log) do
        love.graphics.setColor(utils.fromHex(colors.white, 1 - entry.age / config.log.life))
        love.graphics.print(entry.text, w - input.right - font:getWidth(entry.text), y - index * lineHeight)
    end
end

function Debug:update(dt)
    if not self.enabled then return end

    table.insert(self.frames, dt)
    if #self.frames > config.frames.count then table.remove(self.frames, 1) end

    self.timer = self.timer + dt
    self.wheel.age = self.wheel.age + dt
    for _, entry in ipairs(self.log) do
        entry.age = entry.age + dt
    end
    for index = #self.clicks, 1, -1 do
        local click = self.clicks[index]
        click.age = click.age + dt
        if click.age >= config.ripple.time then table.remove(self.clicks, index) end
    end
end

function Debug:record(event, ...)
    local handler = self["_" .. event]
    if handler and (self.enabled or event == "keypressed") then handler(self, ...) end
end

function Debug:draw(manager)
    if not self.enabled then return end

    if self.timer >= config.interval then
        self.timer = 0
        self:_collect(manager)
    end

    local previousFont = love.graphics.getFont()

    self:_drawCrosshair()
    self:_drawClicks()
    self:_drawDrags()
    self:_drawPanel()
    self:_drawInput()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Debug:drawWorld(simulator)
    if self.enabled then self.world:draw(simulator) end
end

return Debug
