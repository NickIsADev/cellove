local ScrollingBackground = require("src/ui/decor/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollView = require("src/ui/widgets/ScrollView")
local Title = require("src/ui/decor/Title")
local Panel = require("src/ui/Panel")
local Prompt = require("src/ui/overlays/Prompt")
local Tooltip = require("src/ui/overlays/Tooltip")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.rows
local colors = constants.ui.colors

local RowScene = {}
RowScene.__index = RowScene

function RowScene:setup(data, spec)
    self.manager = data.manager
    self.renderer = data.renderer
    self.spec = spec
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, spec.title)
    self.tooltip = Tooltip.new(data.renderer)
    self.prompt = Prompt.new(data.renderer)
    self.reset = IconButton.new({
        renderer = data.renderer,
        folder = "cells",
        texture = config.reset.texture,
        size = config.reset.size,
        title = spec.reset.title,
        description = spec.reset.description
    })
    self.list = ScrollView.new({
        renderer = data.renderer,
        gap = config.row.gap,
        drawRow = function(...) self:_drawRow(...) end
    })
    self.rows = {}
    self.hover = {}
end

function RowScene:_layout()
    local w, h = love.graphics.getDimensions()
    local width = math.min(config.row.width, w - config.row.margin * 2)
    local top = h * config.top.ratio

    self.list:place((w - width) / 2, top, width, h - config.row.bottom - top)
    self.reset:place(w - config.reset.margin - config.reset.size, config.reset.margin)
end

function RowScene:_setRows(rows)
    self.rows = rows
    self.list:setItems(rows)
    for index = 1, #rows do
        self.hover[index] = 0
    end
end

function RowScene:_requestReset()
    local dialog = self.spec.reset.prompt

    self.prompt:open({
        title = dialog.title,
        message = dialog.message,
        confirm = dialog.confirm,
        onConfirm = function() self:_restore() end
    })
end

function RowScene:_drawPanel(index, x, y, width, height)
    Panel.draw(x, y, width, height, { highlight = self.hover[index] })
end

function RowScene:_drawFrame(index, row, x, y, width, height)
    local font = self.renderer:font(config.font.text)

    self:_drawPanel(index, x, y, width, height)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * self.hover[index]))
    love.graphics.print(row.title, x + config.row.pad, y + (height - font:getHeight()) / 2)
    return font
end

function RowScene:_drawRow(index, row, ...)
    self.drawers[row.kind](self, index, row, ...)
end

function RowScene:_describe(row)
    return row.description
end

function RowScene:_drawTooltip()
    local index = self.list:rowAt(love.mouse.getPosition())
    local row = index and self.rows[index]
    local description = row and self:_describe(row)
    if description then self.tooltip:draw(row.title, description) end
end

function RowScene:enter(_, data)
    self.exit = data and data.back or { scene = "menu" }
    self.list:resetScroll()
    self:_layout()
end

function RowScene:update(dt)
    self:_layout()
    self.background:update(dt)

    local mx, my = love.mouse.getPosition()
    local hoveredRow = self.drag or not self.prompt.active and self.list:rowAt(mx, my)
    local ease = math.min(1, constants.ui.hover.speed * dt)

    for index = 1, #self.rows do
        local target = index == hoveredRow and 1 or 0
        self.hover[index] = utils.lerp(self.hover[index], target, ease)
    end

    self.back:update(dt)
    self.reset:update(dt)
    self.prompt:update(dt)
end

function RowScene:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) then return end
    if button ~= 1 then return end

    if self.back:hit(x, y) then return self.manager:switch(self.exit.scene, self.exit.data) end

    if self.reset:hit(x, y) then return self:_requestReset() end

    if self.list:mousepressed(x, y, button) then return end

    local index = self.list:rowAt(x, y)
    if index then self:_press(index, self.rows[index], x, y) end
end

function RowScene:mousemoved(x, y)
    self.list:mousemoved(x, y)
end

function RowScene:wheelmoved(_, y)
    if not self.prompt.active then self.list:wheelmoved(y) end
end

function RowScene:mousereleased(_, _, button)
    if button == 1 then self.list:mousereleased() end
end

function RowScene:keypressed(key)
    if self.prompt:keypressed(key) then return end

    if key == "escape" then self.manager:switch(self.exit.scene, self.exit.data) end
end

function RowScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    self.list:draw()
    self.back:draw()
    self.reset:draw()
    self.prompt:draw()

    if not self.prompt.active then
        self:_drawTooltip()
        self.reset:drawTooltip(self.tooltip)
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return RowScene
