local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.hotkeys.capture
local text = config.text
local key = config.key
local colors = constants.ui.colors

local function layoutKeyboard()
    local unit = key.size + key.gap
    local board = { caps = {}, width = 0 }

    for row, list in ipairs(config.keyboard) do
        local x = 0
        for _, item in ipairs(list) do
            local cap = { x = x, y = (row - 1) * unit }

            if type(item) == "table" then
                cap.label, cap.key, cap.span = item[1], item[2], item[3]
            else
                cap.label, cap.key, cap.span = item:upper(), item, 1
            end
            cap.width = cap.span * unit - key.gap
            board.caps[#board.caps + 1] = cap
            x = x + cap.width + key.gap
        end
        board.width = math.max(board.width, x - key.gap)
    end
    board.height = #config.keyboard * unit - key.gap
    return board
end

local board = layoutKeyboard()

local KeyCapture = {}
KeyCapture.__index = KeyCapture

function KeyCapture.new(data)
    local self = setmetatable({}, KeyCapture)
    self.renderer = data.renderer
    self.hotkeys = data.hotkeys
    self.active = false
    return self
end

function KeyCapture:_drawKeyboard(x, y)
    local font = love.graphics.getFont()

    for _, cap in ipairs(board.caps) do
        local locked = config.locked[cap.key]
        local lit = not locked and love.keyboard.isDown(cap.key)
        local taken = not locked and self.hotkeys:taken(self.hotkeys:chord(cap.key), self.row.id)
        local capX, capY = x + cap.x, y + cap.y

        Panel.draw(capX, capY, cap.width, key.size, { fill = lit and colors.accent or colors.panel, border = taken and colors.warning })
        love.graphics.setColor(utils.fromHex((lit and colors.dark) or (taken and colors.warning) or (locked and colors.muted) or colors.white))
        love.graphics.print(cap.label, capX + (cap.width - font:getWidth(cap.label)) / 2, capY + (key.size - font:getHeight()) / 2)
    end
end

function KeyCapture:open(row)
    self.active = true
    self.row = row
end

function KeyCapture:close()
    self.active = false
end

function KeyCapture:draw()
    if not self.active then return end

    local renderer, fonts = self.renderer, config.font
    local title, name, small = renderer:font(fonts.title), renderer:font(fonts.name), renderer:font(fonts.key)
    local width = board.width + config.pad * 2
    local inner = width - config.pad * 2
    local top = config.pad + title:getHeight() + name:getHeight() + config.gap
    local hintY = top + board.height + config.gap
    local height = hintY + small:getHeight() + config.pad
    local w, h = love.graphics.getDimensions()
    local scale = math.min(1, (w - config.margin * 2) / width, (h - config.margin * 2) / height)
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.push()
    love.graphics.translate((w - width * scale) / 2, (h - height * scale) / 2)
    love.graphics.scale(scale)
    Panel.draw(0, 0, width, height, { alpha = 1 })

    love.graphics.setFont(title)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.printf(text.title, config.pad, config.pad, inner, "center")

    love.graphics.setFont(name)
    love.graphics.setColor(utils.fromHex(colors.white, 0.7))
    love.graphics.printf(string.format(text.name, self.row.title), config.pad, config.pad + title:getHeight(), inner, "center")

    love.graphics.setFont(small)
    self:_drawKeyboard(config.pad, top)
    love.graphics.setColor(utils.fromHex(colors.muted))
    love.graphics.printf(text.hint, config.pad, hintY, inner, "center")

    love.graphics.pop()
    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return KeyCapture
