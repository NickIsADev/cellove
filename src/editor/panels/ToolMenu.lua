local Panel = require("src/ui/Panel")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.toolMenu
local tools = constants.editor.tools.list
local colors = constants.ui.colors

local ToolMenu = {}
ToolMenu.__index = ToolMenu

function ToolMenu.new(data)
    local self = setmetatable({}, ToolMenu)
    self.renderer = data.renderer
    self.hotkeys = data.hotkeys
    self.onPick = data.onPick
    self.active = false
    self.current = 1
    self.index = 1
    self.height = 0
    self.hover = {}
    return self
end

function ToolMenu:_card(index)
    local w, h = love.graphics.getDimensions()
    local card = config.card
    local total = #tools * card.width + (#tools - 1) * card.gap

    return (w - total) / 2 + (index - 1) * (card.width + card.gap), (h - self.height) / 2, card.width, self.height
end

function ToolMenu:_at(x, y)
    for index = 1, #tools do
        if utils.inside(x, y, self:_card(index)) then return index end
    end
end

function ToolMenu:_pick(index)
    Audio.play("click")
    self:close()
    self.onPick(tools[index].id)
end

function ToolMenu:_drawCard(index)
    local tool, card = tools[index], config.card
    local x, y, width, height = self:_card(index)
    local hover = self.hover[index] or 0
    local icon = self.renderer.textures.ui[tool.texture]
    local scale = config.icon / icon:getWidth() * (1 + constants.ui.hover.growth * hover)
    local titleFont = self.renderer:font(config.font.title)
    local textFont = self.renderer:font(config.font.text)
    local keyFont = self.renderer:font(config.font.key)
    local iconY = y + card.pad + config.icon / 2
    local titleY = y + card.pad * 2 + config.icon
    local textY = titleY + titleFont:getHeight() + card.pad / 2

    Panel.draw(x, y, width, height, { alpha = 1 })
    
    local inset = constants.ui.list.row.inset
    Panel.selected(x + inset, y + inset, width - inset * 2, height - inset * 2, hover)

    love.graphics.setColor(utils.fromHex(index == self.current and colors.accent or colors.white, 0.7 + 0.3 * hover))
    love.graphics.draw(icon, x + width / 2, iconY, 0, scale, scale, icon:getWidth() / 2, icon:getHeight() / 2)

    love.graphics.setFont(titleFont)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.printf(tool.title, x, titleY, width, "center")

    love.graphics.setFont(textFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.6))
    love.graphics.printf(tool.description, x + card.pad, textY, width - card.pad * 2, "center")

    love.graphics.setFont(keyFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.4))
    love.graphics.print(tool.key and self.hotkeys:label(tool.id) or "", x + card.pad, y + card.pad)
end

function ToolMenu:_measure()
    local card = config.card
    local titleFont = self.renderer:font(config.font.title)
    local textFont = self.renderer:font(config.font.text)

    local lines = 0
    for _, tool in ipairs(tools) do
        local _, wrapped = textFont:getWrap(tool.description, card.width - card.pad * 2)
        lines = math.max(lines, #wrapped)
    end
    self.height = card.pad * 3.5 + config.icon + titleFont:getHeight() + lines * textFont:getHeight()
end

function ToolMenu:open(id)
    for index, tool in ipairs(tools) do
        if tool.id == id then self.current, self.index = index, index end
    end
    self:_measure()
    self.hover = { [self.index] = 1 }
    self.active = true
end

function ToolMenu:close()
    self.active = false
end

function ToolMenu:update(dt)
    if not self.active then return end

    local ease = math.min(1, constants.ui.hover.speed * dt)
    for index = 1, #tools do
        self.hover[index] = utils.lerp(self.hover[index] or 0, index == self.index and 1 or 0, ease)
    end
end

function ToolMenu:mousemoved(x, y)
    if self.active then self.index = self:_at(x, y) or self.index end
end

function ToolMenu:mousepressed(x, y, button)
    if not self.active then return false end

    local index = self:_at(x, y)
    if button == 1 and index then self:_pick(index) elseif not index then self:close() end
    return true
end

function ToolMenu:keypressed(key)
    if not self.active then return false end

    if key == "escape" or self.hotkeys:pressed("toolMenu", key) then
        self:close()
    elseif key == "return" or key == "kpenter" then
        self:_pick(self.index)
    elseif key == "left" or key == "right" then
        self.index = utils.clamp(self.index + (key == "right" and 1 or -1), 1, #tools)
    else
        for index, tool in ipairs(tools) do
            if self.hotkeys:pressed(tool.id, key) then self:_pick(index) end
        end
    end
    return true
end

function ToolMenu:draw()
    if not self.active then return end

    local w, h = love.graphics.getDimensions()
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    for index = 1, #tools do
        self:_drawCard(index)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return ToolMenu
