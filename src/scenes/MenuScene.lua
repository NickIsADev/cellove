local ScrollingBackground = require("src/ui/decor/ScrollingBackground")
local IconButton = require("src/ui/widgets/IconButton")
local Panel = require("src/ui/Panel")
local Tooltip = require("src/ui/overlays/Tooltip")
local Toast = require("src/ui/overlays/Toast")
local Prompt = require("src/ui/overlays/Prompt")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.menu
local credits = config.credits
local discord = config.discord
local separator = constants.ui.separator
local version = config.version
local info = constants.version
local notice = constants.updates.notice
local alert = constants.mods.alert
local colors = constants.ui.colors
local shadow = constants.ui.shadow

local MenuScene = {}
MenuScene.__index = MenuScene

function MenuScene.new(data)
    local self = setmetatable({}, MenuScene)
    self.manager = data.manager
    self.mods = data.mods
    self.updates = data.updates
    self.toast = Toast.new(data.renderer)
    self.prompt = Prompt.new(data.renderer)
    self.alerted = false
    self.noticed = {}
    self.renderer = data.renderer
    self.background = ScrollingBackground.new(data.renderer)
    self.tooltip = Tooltip.new(data.renderer)

    self.time = 0
    self.splash = ""

    self.buttons = {}
    for _, spec in ipairs(config.button.list) do
        local button = IconButton.new({
            renderer = data.renderer,
            id = spec.id,
            folder = spec.folder,
            texture = spec.texture,
            size = config.button.size,
            glow = true,
            label = spec.title,
            labelFont = config.button.font,
            labelGap = config.button.label.gap
        })
        button.scene = spec.scene
        button.action = spec.action
        self.buttons[#self.buttons + 1] = button
    end

    self.quitButton = IconButton.new({
        renderer = data.renderer,
        id = "quit",
        folder = "ui",
        texture = "x",
        size = config.quit.size,
        tint = colors.danger,
        alpha = config.quit.alpha,
        growth = 0,
        title = config.quit.title,
        description = config.quit.description
    })
    self.creditsButton = IconButton.new({
        renderer = data.renderer,
        id = "credits",
        folder = "ui",
        texture = "credits",
        size = credits.button.size,
        alpha = credits.button.alpha,
        growth = 0,
        title = credits.button.title,
        description = credits.button.description
    })
    self.discordButton = IconButton.new({
        renderer = data.renderer,
        id = "discord",
        folder = "ui",
        texture = "discord",
        size = discord.size,
        alpha = discord.alpha,
        growth = 0,
        title = discord.title,
        description = discord.description
    })
    self.credits = false
    return self
end

function MenuScene:_layout()
    local w, h = love.graphics.getDimensions()
    local size, gap = config.button.size, config.button.gap
    local total = #self.buttons * size + (#self.buttons - 1) * gap

    for index, button in ipairs(self.buttons) do
        button:place((w - total) / 2 + (index - 1) * (size + gap), h * config.button.y - size / 2)
    end
    self.quitButton:place(w - config.quit.margin - config.quit.size, config.quit.margin)
    self.creditsButton:place(credits.button.margin, h - credits.button.margin - credits.button.size)
    self.discordButton:place(credits.button.margin + credits.button.size + discord.gap, h - credits.button.margin - discord.size)
end

function MenuScene:_drawTitle()
    local renderer = self.renderer
    local w, h = love.graphics.getDimensions()
    local limits = config.title.font
    local step = limits.step
    local size = math.max(limits.min, math.min(
        limits.max,
        math.floor(w / limits.width / step) * step,
        math.floor(h / limits.height / step) * step
    ))
    local font = renderer:font(size)
    local lineHeight = font:getHeight()
    local textHeight = #config.title.lines * lineHeight

    local widest = 0
    for _, line in ipairs(config.title.lines) do
        widest = math.max(widest, font:getWidth(line))
    end

    local logo = renderer.textures.cells.cellove
    local logoWidth, logoHeight = logo:getDimensions()
    local logoSize = textHeight * config.title.logo.scale
    local logoScale = logoSize / logoWidth

    local left = (w - (logoSize + config.title.logo.gap + widest)) / 2
    local top = h * config.title.y - textHeight / 2 + math.sin(self.time * config.title.bob.speed) * config.title.bob.height
    local textLeft = left + logoSize + config.title.logo.gap

    utils.drawShadowed(function(ox, oy)
        love.graphics.draw(logo, left + logoSize / 2 + ox, top + textHeight / 2 + oy, 0, logoScale, logoScale, logoWidth / 2, logoHeight / 2)
    end, shadow.offset, shadow.alpha)

    love.graphics.setFont(font)
    for index, line in ipairs(config.title.lines) do
        local y = top + (index - 1) * lineHeight
        utils.drawShadowed(function(ox, oy)
            love.graphics.print(line, textLeft + ox, y + oy)
        end, shadow.offset, shadow.alpha)
    end

    return textLeft + widest, top + textHeight
end

function MenuScene:_drawSplash(x, y)
    local renderer = self.renderer
    local w = love.graphics.getWidth()
    local font = renderer:font(config.splash.size)
    local textWidth = font:getWidth(self.splash)
    local pulse = 1 + math.sin(self.time * config.splash.pulse.speed) * config.splash.pulse.amount
    local scale = math.min(pulse, (w - 32) / textWidth)
    x = math.min(x, w - 16 - textWidth * scale / 2)

    love.graphics.setFont(font)
    utils.drawShadowed(function(ox, oy)
        love.graphics.print(self.splash, x + ox, y + oy, config.splash.angle, scale, scale, textWidth / 2, font:getHeight() / 2)
    end, config.splash.shadow, shadow.alpha, config.splash.color)
end

function MenuScene:_versionLines()
    local text, alpha = version.text, version.alpha
    local latest = self.updates:available()
    local color = utils.prerelease(info.number) and colors.warning or colors.white
    local lines = {
        { text = text.number, color = color, alpha = alpha.number },
        { text = text.build, color = color, alpha = alpha.build }
    }

    if latest then
        lines[#lines + 1] = { text = string.format(text.outdated, latest), color = colors.warning, alpha = alpha.warning }
    end
    return lines
end

function MenuScene:_drawVersion()
    local font = self.renderer:font(version.font)
    local w, h = love.graphics.getDimensions()
    local lines = self:_versionLines()
    local lineHeight = font:getHeight()
    local top = h - credits.button.margin - (credits.button.size + #lines * lineHeight) / 2

    love.graphics.setFont(font)
    for index, line in ipairs(lines) do
        love.graphics.setColor(utils.fromHex(line.color, line.alpha))
        love.graphics.print(line.text, w - version.margin - font:getWidth(line.text), top + (index - 1) * lineHeight)
    end
end

function MenuScene:_drawCredits()
    local panel = credits.panel
    local renderer = self.renderer
    local title, role = renderer:font(panel.font.title), renderer:font(panel.font.role)
    local name, hint = renderer:font(panel.font.name), renderer:font(panel.font.hint)
    local logo = renderer.textures.cells.cellove
    local w, h = love.graphics.getDimensions()

    local header = math.max(title:getHeight(), panel.logo)
    local rows = #credits.entries * panel.row
    local height = panel.pad * 2 + header + panel.gap * 2 + separator.width * 2 + rows + hint:getHeight()
    local x, y = (w - panel.width) / 2, (h - height) / 2
    local left, right = x + panel.pad, x + panel.width - panel.pad

    love.graphics.setColor(utils.fromHex(0x000000, panel.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(x, y, panel.width, height, { alpha = 1 })

    y = y + panel.pad
    local center = y + header / 2
    local logoScale = panel.logo / logo:getWidth()
    utils.drawShadowed(function(ox, oy)
        love.graphics.draw(logo, left + ox, center - panel.logo / 2 + oy, 0, logoScale, logoScale)
    end, shadow.offset, shadow.alpha)

    love.graphics.setFont(title)
    utils.drawShadowed(function(ox, oy)
        love.graphics.print(credits.title, left + panel.logo + panel.gap + ox,
            math.floor(center - title:getBaseline() * (1 - panel.cap / 2)) + oy)
    end, shadow.offset, shadow.alpha)

    y = y + header + panel.gap
    Panel.fill(left, y, right - left, separator.width, colors.white, separator.alpha)

    y = y + separator.width
    for index, item in ipairs(credits.entries) do
        love.graphics.setFont(role)
        love.graphics.setColor(utils.fromHex(colors.muted))
        love.graphics.print(item.role:upper(), left, y + (panel.row - role:getHeight()) / 2)

        love.graphics.setFont(name)
        love.graphics.setColor(utils.fromHex(colors.white))
        love.graphics.print(item.name, right - name:getWidth(item.name), y + (panel.row - name:getHeight()) / 2)

        y = y + panel.row
        if index < #credits.entries then
            Panel.fill(left, y - 1, right - left, 1, colors.white, separator.alpha * 0.5)
        end
    end

    Panel.fill(left, y, right - left, separator.width, colors.white, separator.alpha)

    love.graphics.setFont(hint)
    love.graphics.setColor(utils.fromHex(colors.white, 0.35))
    love.graphics.printf(credits.hint, x, y + separator.width + panel.gap, panel.width, "center")
end

function MenuScene:_alert()
    local failed = self.mods:failed()
    if self.alerted or #failed == 0 then return end

    self.alerted = true
    local message = #failed == 1 and string.format(alert.one, failed[1].name) or string.format(alert.many, #failed)
    self.toast:show(message, true, alert.time)
end

function MenuScene:_notify()
    if self.prompt.active then return end

    local latest = self.updates:available()
    if not self.noticed.prerelease and utils.prerelease(info.number) then
        self.noticed.prerelease = true
        self.prompt:open({
            title = notice.prerelease.title,
            message = notice.prerelease.message,
            confirm = notice.prerelease.confirm,
            cancel = notice.prerelease.cancel,
            onCancel = love.event.quit
        })
    elseif not self.noticed.outdated and latest then
        self.noticed.outdated = true
        self.prompt:open({
            title = notice.outdated.title,
            message = string.format(notice.outdated.message, latest),
            confirm = notice.outdated.confirm,
            onConfirm = function() love.system.openURL(constants.updates.releases) end
        })
    end
end

function MenuScene:_activate(button)
    if button.scene then
        self.manager:switch(button.scene)
    elseif button.action then
        button.action()
    end
end

function MenuScene:enter()
    self.credits = false
    local splashes = config.splash.list
    self.splash = splashes[love.math.random(#splashes)]
    self:_alert()
end

function MenuScene:update(dt)
    self.time = self.time + dt
    self.background:update(dt)
    self.toast:update(dt)
    self.prompt:update(dt)
    self:_notify()
    self:_layout()

    for _, button in ipairs(self.buttons) do button:update(dt) end
    self.quitButton:update(dt)
    self.creditsButton:update(dt)
    self.discordButton:update(dt)
end

function MenuScene:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) or button ~= 1 then return end

    self:_layout()
    if self.credits then
        self.credits = false
        return
    end
    if self.creditsButton:hit(x, y) then
        self.credits = true
        return
    end
    if self.discordButton:hit(x, y) then return love.system.openURL(discord.url) end
    if self.quitButton:hit(x, y) then return love.event.quit() end

    for _, icon in ipairs(self.buttons) do
        if icon:hit(x, y) then return self:_activate(icon) end
    end
end

function MenuScene:keypressed(key)
    if self.prompt:keypressed(key) then return end

    if self.credits then
        self.credits = false
    elseif key == "return" or key == "space" then
        self:_activate(self.buttons[1])
    end
end

function MenuScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    local titleRight, titleBottom = self:_drawTitle()
    self:_drawSplash(titleRight, titleBottom)
    for _, button in ipairs(self.buttons) do button:draw() end
    self.quitButton:draw()
    self.creditsButton:draw()
    self.discordButton:draw()
    self:_drawVersion()
    self.toast:draw(constants.toast.top)
    if self.credits then self:_drawCredits() end
    self.prompt:draw()
    if not self.credits and not self.prompt.active then
        self.quitButton:drawTooltip(self.tooltip)
        self.creditsButton:drawTooltip(self.tooltip)
        self.discordButton:drawTooltip(self.tooltip)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return MenuScene
