local IconButton = require("src/ui/widgets/IconButton")
local Panel = require("src/ui/Panel")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.pauseMenu
local colors = constants.ui.colors

local PauseMenu = {}
PauseMenu.__index = PauseMenu

function PauseMenu.new(data)
    local self = setmetatable({}, PauseMenu)
    self.renderer = data.renderer
    self.buttons = config.layouts[data.layout]
    self.actions = data.actions
    self.onOpen = data.onOpen
    self.tooltip = Tooltip.new(data.renderer)
    self.active = false
    self.index = 1
    self.hover = {}

    self.button = IconButton.new({
        renderer = data.renderer,
        texture = "menu",
        size = config.button.size,
        title = config.button.title,
        description = config.button.description
    })
    self.button:place(config.button.margin, config.button.margin)
    return self
end

function PauseMenu:_width()
    local row = config.row
    local font = self.renderer:font(row.font)
    local text = 0

    for _, spec in ipairs(self.buttons) do
        text = math.max(text, font:getWidth(spec.title))
    end
    return math.max(config.width, text + row.icon + row.gap * 3 + config.pad * 2)
end

function PauseMenu:_row(index)
    local w, h = love.graphics.getDimensions()
    local width = self:_width()
    local height = #self.buttons * config.row.height + config.pad * 2
    local x, y = (w - width) / 2, (h - height) / 2

    return x, y, width, height, x + config.pad, y + config.pad + (index - 1) * config.row.height
end

function PauseMenu:_at(x, y)
    for index = 1, #self.buttons do
        local _, _, width, _, rowX, rowY = self:_row(index)
        if utils.inside(x, y, rowX, rowY, width - config.pad * 2, config.row.height) then return index end
    end
end

function PauseMenu:_pick(index)
    local spec = self.buttons[index]
    local action = spec.action or self.actions[spec.id]

    Audio.play("click")
    self:close()
    if action then action() end
end

function PauseMenu:_drawRow(index)
    local spec, row = self.buttons[index], config.row
    local _, _, width, _, x, y = self:_row(index)
    local hover = self.hover[index] or 0
    local icon = self.renderer.textures[spec.folder][spec.texture]
    local font = self.renderer:font(row.font)
    local scale = row.icon / icon:getWidth()

    local inset = constants.ui.list.row.inset
    Panel.selected(x + inset, y + inset, width - config.pad * 2 - inset * 2, row.height - inset * 2, hover)

    love.graphics.setColor(utils.fromHex(colors[spec.tint or "white"], 0.7 + 0.3 * hover))
    love.graphics.draw(icon, x + row.gap + row.icon / 2, y + row.height / 2, spec.rotation or 0, scale, scale,
        icon:getWidth() / 2, icon:getHeight() / 2)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * hover))
    love.graphics.print(spec.title, x + row.gap * 2 + row.icon, y + (row.height - font:getHeight()) / 2)
end

function PauseMenu:setLayout(layout)
    self.buttons = config.layouts[layout]
end

function PauseMenu:open()
    self.index = 1
    self.hover = { 1 }
    self.active = true
    self.onOpen()
end

function PauseMenu:close()
    self.active = false
end

function PauseMenu:contains(x, y)
    return self.button:contains(x, y)
end

function PauseMenu:update(dt)
    self.button:update(dt)

    local ease = math.min(1, constants.ui.hover.speed * dt)
    for index = 1, #self.buttons do
        self.hover[index] = utils.lerp(self.hover[index] or 0, self.active and index == self.index and 1 or 0, ease)
    end
end

function PauseMenu:mousemoved(x, y)
    if self.active then self.index = self:_at(x, y) or self.index end
end

function PauseMenu:mousepressed(x, y, button)
    if self.active then
        local index = self:_at(x, y)
        if button == 1 and index then self:_pick(index) elseif not index then self:close() end
        return true
    end

    if button == 1 and self.button:hit(x, y) then
        self:open()
        return true
    end
    return false
end

function PauseMenu:keypressed(key)
    if not self.active then return false end

    if key == "escape" then
        self:close()
    elseif key == "return" or key == "kpenter" then
        self:_pick(self.index)
    elseif key == "up" or key == "down" then
        self.index = utils.clamp(self.index + (key == "down" and 1 or -1), 1, #self.buttons)
    end
    return true
end

function PauseMenu:draw()
    local previousFont = love.graphics.getFont()

    self.button:draw()
    if self.active then
        local w, h = love.graphics.getDimensions()
        local x, y, width, height = self:_row(1)

        love.graphics.setColor(utils.fromHex(0x000000, config.dim))
        love.graphics.rectangle("fill", 0, 0, w, h)
        Panel.draw(x, y, width, height, { alpha = 1 })
        for index = 1, #self.buttons do
            self:_drawRow(index)
        end
    else
        self.button:drawTooltip(self.tooltip)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return PauseMenu
