local IconButton = require("src/ui/widgets/IconButton")
local ScrollList = require("src/ui/widgets/ScrollList")
local Panel = require("src/ui/Panel")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.stamps
local text = config.text
local row = config.row
local colors = constants.ui.colors

local function deleteBox(x, y, width, height)
    return x + width - row.delete - row.pad, y + (height - row.delete) / 2, row.delete
end

local StampList = {}
StampList.__index = StampList

function StampList.new(data)
    local self = setmetatable({}, StampList)
    self.renderer = data.renderer
    self.stamps = data.stamps
    self.prompt = data.prompt
    self.onPick = data.onPick
    self.tooltip = Tooltip.new(data.renderer)
    self.active = false
    self.box = {}

    self.exit = IconButton.new({
        renderer = data.renderer,
        folder = "ui",
        texture = "x",
        size = config.exit.size,
        tint = colors.danger,
        title = config.exit.title,
        description = config.exit.description
    })
    self.folder = IconButton.new({
        renderer = data.renderer,
        folder = "ui",
        texture = "folder",
        size = config.folder.size,
        title = config.folder.title,
        description = config.folder.description
    })
    self.list = ScrollList.new({
        renderer = data.renderer,
        rowHeight = row.height,
        emptyText = text.empty,
        emptyFont = config.font.empty,
        drawRow = function(...) self:_drawRow(...) end
    })
    return self
end

function StampList:_layout()
    local w, h = love.graphics.getDimensions()
    local box, size = self.box, config.folder.size

    box.width, box.height = math.min(config.width, w - config.margin * 2), math.min(config.height, h - config.margin * 2)
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2

    local listY = box.y + config.pad + size + config.gap
    self.exit:place(box.x + box.width - config.pad - config.exit.size, box.y + config.pad)
    self.folder:place(self.exit.x - config.gap - size, box.y + config.pad)
    self.list:place(box.x + config.pad, listY, box.width - config.pad * 2, box.y + box.height - config.pad - listY)
end

function StampList:_refresh()
    local entries = self.stamps:list()
    self.list:setItems(entries, #entries > 0 and 1 or nil)
end

function StampList:_pick(entry)
    local data = entry and entry.valid and self.stamps:load(entry.name)
    if not data then return end

    self:close()
    self.onPick(data)
end

function StampList:_delete(entry)
    if not entry then return end

    self.prompt:open({
        title = text.delete.title,
        message = string.format(text.delete.message, entry.name),
        confirm = text.delete.confirm,
        onConfirm = function()
            self.stamps:delete(entry.name)
            self:_refresh()
        end
    })
end

function StampList:_drawRow(entry, x, y, width, height, hover, selected)
    local nameFont = self.renderer:font(row.font.name)
    local detailFont = self.renderer:font(row.font.detail)
    local icon = self.renderer.textures.ui.stamp
    local textX = x + row.pad * 2 + row.icon
    local textWidth = x + width - row.delete - row.pad * 3 - textX
    local nameY = y + (height - nameFont:getHeight() - row.lineGap - detailFont:getHeight()) / 2
    local bx, by, size = deleteBox(x, y, width, height)

    love.graphics.setColor(utils.fromHex(colors.white, entry.valid and 1 or 0.5))
    love.graphics.draw(icon, x + row.pad, y + (height - row.icon) / 2, 0, row.icon / icon:getWidth(), row.icon / icon:getHeight())

    love.graphics.setFont(nameFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * (selected and 1 or hover)))
    utils.printFitted(entry.name, textX, nameY, textWidth)

    love.graphics.setFont(detailFont)
    if entry.valid then
        love.graphics.setColor(utils.fromHex(colors.white, 0.5))
        utils.printFitted(string.format(text.detail, entry.width, entry.height, entry.count),
            textX, nameY + nameFont:getHeight() + row.lineGap, textWidth)
    else
        love.graphics.setColor(utils.fromHex(colors.danger, 0.8))
        utils.printFitted(text.invalid, textX, nameY + nameFont:getHeight() + row.lineGap, textWidth)
    end

    local remove = self.renderer.textures.cells.trash
    local alpha = utils.inside(love.mouse.getX(), love.mouse.getY(), bx, by, size, size) and 1 or 0.6

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(remove, bx, by, 0, size / remove:getWidth(), size / remove:getHeight())
end

function StampList:_drawTooltip()
    local mx, my = love.mouse.getPosition()
    local index = self.list:rowAt(mx, my)

    if index then
        local bx, by, size = deleteBox(self.list:bounds(index))
        if utils.inside(mx, my, bx, by, size, size) then self.tooltip:draw(text.remove.title, text.remove.description) end
    end
    self.folder:drawTooltip(self.tooltip)
    self.exit:drawTooltip(self.tooltip)
end

function StampList:open()
    self.active = true
    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)

    self:_layout()
    self.list:resetScroll()
    self:_refresh()
end

function StampList:close()
    self.active = false
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function StampList:update(dt)
    if not self.active then return end

    self:_layout()
    self.exit:update(dt)
    self.folder:update(dt)
    self.list:update(dt, not self.prompt.active)
end

function StampList:mousepressed(x, y, button)
    if not self.active then return false end

    self:_layout()
    if button ~= 1 then return true end

    local box = self.box
    if self.exit:hit(x, y) or not utils.inside(x, y, box.x, box.y, box.width, box.height) then
        self:close()
    elseif self.folder:hit(x, y) then
        self.stamps:open()
    elseif not self.list:mousepressed(x, y, button) then
        local index = self.list:rowAt(x, y)
        local entry = self.list.items[index]
        if not entry then return true end

        Audio.play("click")
        local bx, by, size = deleteBox(self.list:bounds(index))
        if utils.inside(x, y, bx, by, size, size) then self:_delete(entry) else self:_pick(entry) end
    end
    return true
end

function StampList:mousemoved(x, y)
    self.list:mousemoved(x, y)
end

function StampList:mousereleased()
    self.list:mousereleased()
end

function StampList:keypressed(key)
    if not self.active then return false end

    if key == "escape" then
        self:close()
    elseif key == "return" or key == "kpenter" then
        self:_pick(self.list:current())
    elseif key == "delete" then
        self:_delete(self.list:current())
    elseif key == "up" then
        self.list:move(-1)
    elseif key == "down" then
        self.list:move(1)
    end
    return true
end

function StampList:wheelmoved(_, y)
    if not self.active then return false end

    self.list:wheelmoved(y)
    return true
end

function StampList:draw()
    if not self.active then return end

    self:_layout()
    local w, h = love.graphics.getDimensions()
    local box = self.box
    local font = self.renderer:font(config.font.title)
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.print(text.title, box.x + config.pad, self.folder.y + (self.folder.height - font:getHeight()) / 2)

    self.exit:draw()
    self.folder:draw()
    self.list:draw()
    if not self.prompt.active then self:_drawTooltip() end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return StampList
