local utf8 = require("utf8")
local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.field
local colors = constants.ui.colors

local function offset(text, index)
    return utf8.offset(text, index + 1) or #text + 1
end

local function blank(text, index)
    return text:sub(offset(text, index - 1), offset(text, index) - 1):match("%s") ~= nil
end

local function edge(text, index, direction)
    local length, step = utf8.len(text), direction > 0 and 1 or 0

    for _, spaces in ipairs({ true, false }) do
        while index + step > 0 and index + step <= length and blank(text, index + step) == spaces do
            index = index + direction
        end
    end
    return index
end

local TextField = setmetatable({}, { __index = Widget })
TextField.__index = TextField

function TextField.new(data)
    local self = setmetatable({}, TextField)
    self:setup({ renderer = data.renderer, width = data.width, height = config.height })
    self.key = data.key
    self.label = data.label
    self.labelWidth = config.label
    self.placeholder = data.placeholder or ""
    self.limit = data.limit or config.limit
    self.filter = data.filter
    self.focused = data.focused ~= false
    self.dragging = false
    self.scroll = 0
    self.clock = 0
    self:set(data.value or "")
    return self
end

function TextField:_left()
    return self.label and self.labelWidth or 0
end

function TextField:_range()
    if not self.anchor or self.anchor == self.cursor then return end
    return math.min(self.anchor, self.cursor), math.max(self.anchor, self.cursor)
end

function TextField:_selected()
    local low, high = self:_range()
    return low and self.text:sub(offset(self.text, low), offset(self.text, high) - 1)
end

function TextField:_erase()
    local low, high = self:_range()
    self.anchor = nil
    if not low then return false end

    self.text = self.text:sub(1, offset(self.text, low) - 1) .. self.text:sub(offset(self.text, high))
    self.cursor = low
    return true
end

function TextField:_move(index, extend)
    self.anchor = extend and (self.anchor or self.cursor) or nil
    self.cursor = index
end

function TextField:_step(direction, byWord)
    if byWord then return edge(self.text, self.cursor, direction) end
    return utils.clamp(self.cursor + direction, 0, utf8.len(self.text))
end

function TextField:_at(x)
    local font = self.renderer:font(config.font)
    local target = x - self.x - self:_left() - config.pad - self.scroll
    local index, nearest = 0, math.huge

    for i = 0, utf8.len(self.text) do
        local distance = math.abs(font:getWidth(self.text:sub(1, offset(self.text, i) - 1)) - target)
        if distance < nearest then index, nearest = i, distance end
    end
    return index
end

function TextField:get()
    return self.text
end

function TextField:set(text)
    self.text, self.cursor, self.anchor = text, utf8.len(text), nil
end

function TextField:mousepressed(x, y, button)
    self.focused = button == 1 and self:contains(x, y)
    self.dragging = self.focused
    if self.focused then self:_move(self:_at(x)) end
    return self.focused
end

function TextField:mousemoved(x)
    if self.dragging then self:_move(self:_at(x), true) end
end

function TextField:mousereleased()
    self.dragging = false
end

function TextField:textinput(text)
    text = text:gsub("%c", "")
    if self.filter then text = text:gsub(self.filter, "") end
    if text == "" then return false end

    self:_erase()
    local room = self.limit - utf8.len(self.text)
    if room <= 0 then return false end

    local at = offset(self.text, self.cursor)
    text = text:sub(1, offset(text, room) - 1)
    self.text = self.text:sub(1, at - 1) .. text .. self.text:sub(at)
    self.cursor = self.cursor + utf8.len(text)
    self.clock = 0
    return true
end

function TextField:keypressed(key)
    local ctrl = love.keyboard.isDown("lctrl", "rctrl")
    local shift = love.keyboard.isDown("lshift", "rshift")
    local low, high = self:_range()
    self.clock = 0

    if key == "backspace" or key == "delete" then
        if not low then self:_move(self:_step(key == "backspace" and -1 or 1, ctrl), true) end
        self:_erase()
    elseif key == "left" or key == "right" then
        local direction = key == "left" and -1 or 1
        if low and not shift then
            self:_move(direction < 0 and low or high)
        else
            self:_move(self:_step(direction, ctrl), shift)
        end
    elseif key == "home" or key == "end" then
        self:_move(key == "home" and 0 or utf8.len(self.text), shift)
    elseif ctrl and key == "a" then
        self.anchor, self.cursor = 0, utf8.len(self.text)
    elseif ctrl and (key == "c" or key == "x") then
        if low then love.system.setClipboardText(self:_selected()) end
        if key == "x" then self:_erase() end
    elseif ctrl and key == "v" then
        return self:textinput(love.system.getClipboardText())
    else
        return false
    end
    return true
end

function TextField:update(dt)
    Widget.update(self, dt)
    self.clock = self.clock + dt
end

function TextField:draw()
    local font = self.renderer:font(config.font)
    local previousFont = love.graphics.getFont()
    local x, width = self.x + self:_left(), self.width - self:_left()
    local inner = width - config.pad * 2
    local y = self.y + (self.height - font:getHeight()) / 2
    local low, high = self:_range()

    local function span(index)
        return font:getWidth(self.text:sub(1, offset(self.text, index) - 1))
    end

    local caret = span(self.cursor)
    self.scroll = math.min(0, utils.clamp(self.scroll, -caret, inner - caret - config.caret))
    local origin = x + config.pad + self.scroll

    love.graphics.setFont(font)
    if self.label then
        love.graphics.setColor(utils.fromHex(colors.white, 0.8))
        love.graphics.print(self.label, self.x, y)
    end

    Panel.draw(x, self.y, width, self.height, {
        fill = colors.dark,
        alpha = 1,
        border = colors.white,
        borderAlpha = 0.6
    })

    love.graphics.setScissor(x + config.pad, self.y, inner, self.height)
    if low then Panel.fill(origin + span(low), y, span(high) - span(low), font:getHeight(), colors.white, config.selection) end
    if self.text == "" then
        love.graphics.setColor(utils.fromHex(colors.white, 0.4))
        love.graphics.print(self.placeholder, x + config.pad, y)
    end
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(self.text, origin, y)
    if self.focused and self.clock % (config.blink * 2) < config.blink then
        Panel.fill(origin + caret, y, config.caret, font:getHeight(), colors.white, 1)
    end
    love.graphics.setScissor()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return TextField
