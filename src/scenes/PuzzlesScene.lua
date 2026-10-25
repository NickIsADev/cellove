local ScrollingBackground = require("src/ui/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollList = require("src/ui/widgets/ScrollList")
local Title = require("src/ui/Title")
local Panel = require("src/ui/Panel")
local Prompt = require("src/ui/overlays/Prompt")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.puzzles
local colors = constants.ui.colors

local PuzzlesScene = {}
PuzzlesScene.__index = PuzzlesScene

function PuzzlesScene.new(data)
    local self = setmetatable({}, PuzzlesScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.puzzles = data.puzzles
    self.progress = data.progress
    self.solved = 0
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, config.title)
    self.tooltip = Tooltip.new(data.renderer)
    self.prompt = Prompt.new(data.renderer)
    self.wipe = IconButton.new({
        renderer = data.renderer,
        folder = "cells",
        texture = config.wipe.texture,
        size = config.wipe.size,
        title = config.wipe.title,
        description = config.wipe.description
    })
    self.list = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.row.height,
        emptyText = config.empty,
        emptyFont = constants.ui.back.font,
        drawRow = function(...) self:_drawRow(...) end
    })
    return self
end

function PuzzlesScene:_layout()
    local w, h = love.graphics.getDimensions()
    local width = math.min(config.width, w - config.margin * 2)
    local top = h * config.top.ratio + config.summary.height

    self.list:place((w - width) / 2, top, width, h - config.margin - top)
    self.wipe:place(w - config.wipe.margin - config.wipe.size, config.wipe.margin)
end

function PuzzlesScene:_requestWipe()
    local dialog = config.wipe.prompt

    self.prompt:open({
        title = dialog.title,
        message = dialog.message,
        confirm = dialog.confirm,
        onConfirm = function()
            self.progress:reset()
            self.solved = 0
        end
    })
end

function PuzzlesScene:_play(puzzle)
    if puzzle then self.manager:switch("puzzle", { id = puzzle.id }) end
end

function PuzzlesScene:_drawSummary()
    local summary, total = config.summary, #self.puzzles:list()
    if total == 0 then return end

    local font = self.renderer:font(summary.font)
    local w, h = love.graphics.getDimensions()
    local y = h * config.top.ratio
    local barY = y + font:getHeight() + summary.gap
    local barX = (w - summary.bar.width) / 2

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.7))
    love.graphics.printf(string.format(summary.text, self.solved, total), 0, y, w, "center")

    Panel.fill(barX, barY, summary.bar.width, summary.bar.height, colors.track, 1)
    Panel.fill(barX, barY, summary.bar.width * self.solved / total, summary.bar.height, colors.accent, 1)
end

function PuzzlesScene:_drawBadge(puzzle, x, y, solved)
    local badge = config.row.badge
    local renderer = self.renderer

    Panel.fill(x, y, badge.size, badge.size, colors.dark, 0.6)
    Panel.outline(x, y, badge.size, badge.size, solved and colors.accent or colors.border, 1)

    if solved then
        local icon = renderer.textures.ui.checkmark
        local scale = badge.icon / icon:getWidth()

        love.graphics.setColor(utils.fromHex(colors.accent))
        love.graphics.draw(icon, x + badge.size / 2, y + badge.size / 2, 0, scale, scale, icon:getWidth() / 2, icon:getHeight() / 2)
    else
        local font = renderer:font(config.row.font.number)
        local number = tostring(puzzle.number)

        love.graphics.setFont(font)
        love.graphics.setColor(utils.fromHex(colors.white, 0.6))
        love.graphics.print(number, x + (badge.size - font:getWidth(number)) / 2, y + (badge.size - font:getHeight()) / 2)
    end
end

function PuzzlesScene:_drawRow(puzzle, x, y, width, height, hover, selected)
    local row = config.row
    local nameFont = self.renderer:font(row.font.name)
    local detailFont = self.renderer:font(row.font.detail)
    local level = config.difficulties[puzzle.difficulty]
    local icon = self.renderer.textures.ui[level.texture]
    local levelWidth = row.level.icon + row.level.gap + detailFont:getWidth(level.title)
    local levelX = x + width - row.pad - levelWidth
    local textX = x + row.pad * 2 + row.badge.size
    local nameY = y + (height - nameFont:getHeight() - row.lineGap - detailFont:getHeight()) / 2

    self:_drawBadge(puzzle, x + row.pad, y + (height - row.badge.size) / 2, self.progress:has(puzzle.id))

    love.graphics.setFont(nameFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * (selected and 1 or hover)))
    utils.printFitted(puzzle.name, textX, nameY, levelX - row.pad - textX)

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(icon, levelX, nameY + (nameFont:getHeight() - row.level.icon) / 2, 0,
        row.level.icon / icon:getWidth(), row.level.icon / icon:getHeight())

    love.graphics.setFont(detailFont)
    love.graphics.setColor(utils.fromHex(level.color, 0.9))
    love.graphics.print(level.title, levelX + row.level.icon + row.level.gap, nameY + (nameFont:getHeight() - detailFont:getHeight()) / 2)

    love.graphics.setColor(utils.fromHex(colors.white, 0.5))
    utils.printFitted(puzzle.description, textX, nameY + nameFont:getHeight() + row.lineGap, x + width - row.pad - textX)
end

function PuzzlesScene:enter(_, data)
    local items = self.puzzles:list()
    local selected = #items > 0 and 1 or nil

    self.solved = 0
    for index, puzzle in ipairs(items) do
        if data and puzzle.id == data.select then selected = index end
        if self.progress:has(puzzle.id) then self.solved = self.solved + 1 end
    end

    self:_layout()
    self.list:resetScroll()
    self.list:setItems(items, selected)
end

function PuzzlesScene:update(dt)
    self:_layout()
    self.background:update(dt)
    self.back:update(dt)
    self.wipe:update(dt)
    self.prompt:update(dt)
    self.list:update(dt, not self.prompt.active)
end

function PuzzlesScene:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) or button ~= 1 then return end

    if self.back:hit(x, y) then return self.manager:switch("menu") end
    if self.wipe:hit(x, y) then return self:_requestWipe() end
    if self.list:mousepressed(x, y, button) then return end

    local index = self.list:rowAt(x, y)
    if index then
        Audio.play("click")
        self:_play(self.list.items[index])
    end
end

function PuzzlesScene:mousemoved(x, y)
    self.list:mousemoved(x, y)
end

function PuzzlesScene:mousereleased()
    self.list:mousereleased()
end

function PuzzlesScene:wheelmoved(_, y)
    if not self.prompt.active then self.list:wheelmoved(y) end
end

function PuzzlesScene:keypressed(key)
    if self.prompt:keypressed(key) then return end

    if key == "escape" then
        self.manager:switch("menu")
    elseif key == "up" then
        self.list:move(-1)
    elseif key == "down" then
        self.list:move(1)
    elseif key == "return" or key == "kpenter" then
        self:_play(self.list:current())
    end
end

function PuzzlesScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    self:_drawSummary()
    self.list:draw()
    self.back:draw()
    self.wipe:draw()
    self.prompt:draw()
    if not self.prompt.active then self.wipe:drawTooltip(self.tooltip) end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return PuzzlesScene
