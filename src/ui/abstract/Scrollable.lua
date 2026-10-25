local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.list
local colors = constants.ui.colors

local Scrollable = {}
Scrollable.__index = Scrollable

function Scrollable:setup(data)
    self.renderer = data.renderer
    self.pad = data.pad or 0
    self.gap = data.gap or 0
    self.items = {}
    self.offsets = {}
    self.scroll = 0
    self.maxScroll = 0
    self.fade = 1
    self.x, self.y, self.width, self.height = 0, 0, 0, 0
end

function Scrollable:_inner()
    return self.x + self.pad, self.y + self.pad, self.width - self.pad * 2, self.height - self.pad * 2
end

function Scrollable:_rowY(index)
    local _, top = self:_inner()
    return top + self.offsets[index] - self.scroll
end

function Scrollable:_rowWidth()
    local _, _, width = self:_inner()
    return self.maxScroll > 0 and width - config.scroll.width - config.scroll.gap or width
end

function Scrollable:_scrollTo(value)
    self.scroll = utils.clamp(value, 0, self.maxScroll)
end

function Scrollable:_measure()
    local _, _, _, height = self:_inner()
    local total = 0

    for index in ipairs(self.items) do
        self.offsets[index] = total
        total = total + self:heightOf(index) + self.gap
    end

    self.maxScroll = math.max(0, total - self.gap - height)
    self:_scrollTo(self.scroll)
end

function Scrollable:_thumb()
    local left, top, width, height = self:_inner()
    local size = math.max(config.scroll.min, height * height / (height + self.maxScroll))
    local y = top + (height - size) * self.scroll / self.maxScroll
    return left + width - config.scroll.width, y, config.scroll.width, size
end

function Scrollable:_drag(y)
    local _, top, _, height = self:_inner()
    local _, _, _, size = self:_thumb()
    self:_scrollTo((y - self.grab - top) / (height - size) * self.maxScroll)
end

function Scrollable:_drawScrollbar()
    if self.maxScroll <= 0 then return end

    local x, y, width, height = self:_thumb()
    Panel.fill(x, y, width, height, colors.white, (self.grab and 0.7 or 0.4) * self.fade)
end

function Scrollable:_clip()
    return self:_inner()
end

function Scrollable:heightOf(index)
    return 0
end

function Scrollable:drawItem(index, item, x, y, width, height)
end

function Scrollable:place(x, y, width, height)
    self.x, self.y, self.width, self.height = x, y, width, height
    self:_measure()
end

function Scrollable:setItems(items)
    self.items = items
    self:_measure()
end

function Scrollable:bounds(index)
    local left = self:_inner()
    return left, self:_rowY(index), self:_rowWidth(), self:heightOf(index)
end

function Scrollable:rowAt(x, y)
    local left, top, _, height = self:_inner()
    if not utils.inside(x, y, left, top, self:_rowWidth(), height) then return end

    for index = 1, #self.items do
        local rowY = self:_rowY(index)
        if y >= rowY and y <= rowY + self:heightOf(index) then return index end
    end
end

function Scrollable:reveal(index)
    local _, top, _, height = self:_inner()
    local offset = self:_rowY(index) - top
    local size = self:heightOf(index)

    if offset < 0 then
        self:_scrollTo(self.scroll + offset)
    elseif offset + size > height then
        self:_scrollTo(self.scroll + offset + size - height)
    end
end

function Scrollable:resetScroll()
    self.scroll = 0
end

function Scrollable:mousepressed(x, y, button)
    if button ~= 1 or self.maxScroll <= 0 then return false end

    local _, top, _, height = self:_inner()
    local bx, by, width, size = self:_thumb()
    local margin = config.scroll.width
    if not utils.inside(x, y, bx - margin, top, width + margin * 2, height) then return false end

    self.grab = utils.inside(x, y, bx, by, width, size) and y - by or size / 2
    self:_drag(y)
    return true
end

function Scrollable:mousemoved(x, y)
    if self.grab then self:_drag(y) end
end

function Scrollable:mousereleased()
    self.grab = nil
end

function Scrollable:wheelmoved(y)
    self:_scrollTo(self.scroll - y * config.scroll.step)
end

function Scrollable:drawItems()
    local left, top, width, height = self:_clip()

    love.graphics.setScissor(left, top, width, height)
    for index, item in ipairs(self.items) do
        local x, y, rowWidth, rowHeight = self:bounds(index)
        if y + rowHeight >= top and y <= top + height then
            self:drawItem(index, item, x, y, rowWidth, rowHeight)
        end
    end
    love.graphics.setScissor()

    self:_drawScrollbar()
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Scrollable
