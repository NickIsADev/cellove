local Scrollable = require("src/ui/abstract/Scrollable")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.list
local colors = constants.ui.colors

local ScrollList = setmetatable({}, { __index = Scrollable })
ScrollList.__index = ScrollList

function ScrollList.new(data)
    local self = setmetatable({}, ScrollList)
    self:setup({ renderer = data.renderer, pad = config.pad })
    self.rowHeight = data.rowHeight
    self.drawRow = data.drawRow
    self.emptyText = data.emptyText or ""
    self.emptyFont = data.emptyFont
    self.hover = {}
    self.slide = {}
    self.open = 0
    return self
end

function ScrollList:_drawBackdrop(index, x, y, width, height)
    local row = config.row
    local inset = row.inset
    local bx, by = x + inset, y + inset
    local bw, bh = width - inset * 2, height - inset * 2

    if index == self.selected then
        Panel.fill(bx, by, bw, bh, colors.white, row.selected * self.fade)
        Panel.outline(bx, by, bw, bh, colors.white, row.outline * self.fade)
    else
        Panel.fill(bx, by, bw, bh, colors.white, row.hover * (self.hover[index] or 0) * self.fade)
    end

    local beside = index == self.selected or index + 1 == self.selected
    if index < #self.items and not beside then
        Panel.fill(x + inset, y + height - 1, width - inset * 2, 1, colors.white, row.separator * self.fade)
    end
end

function ScrollList:heightOf()
    return self.rowHeight
end

function ScrollList:_drawHole()
    if not self.holeAt then return end

    local left, top = self:_inner()
    local inset = config.row.inset
    local height = self.rowHeight * self.open - inset * 2
    if height <= 0 then return end

    local x, y, width = left + inset, top + self.holeAt - self.scroll + inset, self:_rowWidth() - inset * 2
    Panel.placeholder(x, y, width, height, self.fade)
end

function ScrollList:drawItem(index, item, x, y, width, height)
    if item == self.held then return end

    y = y + (self.slide[index] or 0)
    self:_drawBackdrop(index, x, y, width, height)
    self.drawRow(item, x, y, width, height, self.hover[index] or 0, index == self.selected)
end

function ScrollList:setItems(items, selected)
    Scrollable.setItems(self, items)
    self.selected = selected
    self.hover = {}
    self.slide, self.open, self.holeAt = {}, 0, nil
    if selected then self:reveal(selected) end
end

function ScrollList:current()
    return self.selected and self.items[self.selected]
end

function ScrollList:select(index)
    self.selected = index
    if index then self:reveal(index) end
end

function ScrollList:move(step)
    if #self.items == 0 then return end

    local start = self.selected or (step > 0 and 0 or #self.items + 1)
    self:select(utils.clamp(start + step, 1, #self.items))
end

function ScrollList:setHole(slot, vacant)
    self.slot, self.vacant = slot, vacant
end

function ScrollList:update(dt, active)
    local hovered = active and self:rowAt(love.mouse.getPosition())
    local ease = math.min(1, constants.ui.hover.speed * dt)
    local slide = math.min(1, config.slide * dt)
    local height = self.rowHeight

    for index = 1, #self.items do
        local shift = (self.slot and index >= self.slot and height or 0) - (self.vacant and index > self.vacant and height or 0)

        self.hover[index] = utils.lerp(self.hover[index] or 0, index == hovered and 1 or 0, ease)
        self.slide[index] = utils.lerp(self.slide[index] or 0, shift, slide)
    end

    self.open = utils.lerp(self.open, self.slot and 1 or 0, slide)
    if self.slot then
        local at = (self.slot - 1) * height - (self.vacant and self.slot > self.vacant and height or 0)
        self.holeAt = self.holeAt and utils.lerp(self.holeAt, at, slide) or at
    elseif self.open < 0.01 then
        self.holeAt = nil
    end
end

function ScrollList:draw()
    local left, top, width, height = self:_inner()
    Panel.draw(self.x, self.y, self.width, self.height, {
        fade = self.fade,
        border = self.target and colors.white,
        borderAlpha = self.target and config.target
    })

    love.graphics.setScissor(left, top, width, height)
    self:_drawHole()
    love.graphics.setScissor()

    if #self.items == 0 then
        if self.slot then return end

        local font = self.renderer:font(self.emptyFont)
        love.graphics.setFont(font)
        love.graphics.setColor(utils.fromHex(colors.white, 0.5))
        love.graphics.printf(self.emptyText, left, top + height / 2 - font:getHeight() / 2, width, "center")
        return
    end

    self:drawItems()
end

return ScrollList
