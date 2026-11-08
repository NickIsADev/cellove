local RowScene = require("src/scenes/abstract/RowScene")
local KeyCapture = require("src/ui/overlays/KeyCapture")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.hotkeys
local layout = constants.rows
local colors = constants.ui.colors

local HotkeysScene = setmetatable({}, { __index = RowScene })
HotkeysScene.__index = HotkeysScene

function HotkeysScene.new(data)
    local self = setmetatable({}, HotkeysScene)
    self:setup(data, config)
    self.hotkeys = data.hotkeys
    self.capture = KeyCapture.new({ renderer = data.renderer, hotkeys = data.hotkeys })
    self.drawers = {
        heading = self._drawHeading,
        hotkey = self._drawHotkey
    }

    local rows = {}
    local group
    for _, hotkey in ipairs(self.hotkeys.list) do
        if hotkey.group ~= group then
            group = hotkey.group
            rows[#rows + 1] = { kind = "heading", title = group, height = config.heading }
        end
        rows[#rows + 1] = {
            kind = "hotkey",
            id = hotkey.id,
            title = hotkey.title,
            description = hotkey.description,
            height = layout.row.height
        }
    end
    self:_setRows(rows)
    return self
end

function HotkeysScene:_drawHeading(_, row, x, y, _, height)
    local font = self.renderer:font(layout.font.text)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.muted))
    love.graphics.print(row.title, x, y + (height - font:getHeight()) / 2)
end

function HotkeysScene:_drawHotkey(index, row, x, y, width, height)
    local font = self:_drawFrame(index, row, x, y, width, height)
    local text = self.hotkeys:label(row.id)
    local tint = #self.hotkeys:conflicts(row.id) > 0 and colors.warning or colors.white

    love.graphics.setColor(utils.fromHex(tint))
    love.graphics.print(text, x + width - layout.row.pad - font:getWidth(text), y + (height - font:getHeight()) / 2)
end

function HotkeysScene:_describe(row)
    local titles = row.id and self.hotkeys:conflicts(row.id) or {}
    return #titles > 0 and string.format(config.conflict, table.concat(titles, ", ")) or row.description
end

function HotkeysScene:_press(_, row)
    if row.kind ~= "hotkey" then return end

    self.listening = row.id
    self.capture:open(row)
    Audio.play("click")
end

function HotkeysScene:_stop()
    self.listening = nil
    self.capture:close()
end

function HotkeysScene:_restore()
    self.hotkeys:reset()
end

function HotkeysScene:enter(...)
    self:_stop()
    RowScene.enter(self, ...)
end

function HotkeysScene:draw()
    RowScene.draw(self)
    self.capture:draw()
end

function HotkeysScene:mousepressed(...)
    self:_stop()
    RowScene.mousepressed(self, ...)
end

function HotkeysScene:keypressed(key)
    if not self.listening then return RowScene.keypressed(self, key) end

    if config.ignored[key] then return end

    if key ~= "escape" then
        self.hotkeys:bind(self.listening, self.hotkeys:chord(key))
        Audio.play("click")
    end
    self:_stop()
end

return HotkeysScene
