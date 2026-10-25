local ScrollingBackground = require("src/ui/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollList = require("src/ui/widgets/ScrollList")
local Title = require("src/ui/Title")
local Avatar = require("src/ui/Avatar")
local Panel = require("src/ui/Panel")
local Lift = require("src/ui/Lift")
local Toast = require("src/ui/overlays/Toast")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local Game = require("src/engine/Game")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.selection
local colors = constants.ui.colors
local motion = config.drag

local steps = { up = -1, down = 1 }
local sides = { left = "available", right = "active" }

local function byName(a, b)
    return a.name:lower() < b.name:lower()
end

local SelectScene = {}
SelectScene.__index = SelectScene

function SelectScene:setup(data, spec, source)
    self.manager = data.manager
    self.renderer = data.renderer
    self.spec = spec
    self.source = source
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, spec.title)
    self.tooltip = Tooltip.new(data.renderer)
    self.toast = Toast.new(data.renderer)
    self.folder = IconButton.new({
        renderer = data.renderer,
        folder = "ui",
        texture = spec.folder.texture,
        size = spec.folder.size,
        title = spec.folder.title,
        description = spec.folder.description
    })
    self.available = self:_list(spec.available)
    self.active = self:_list(spec.active)
    self.lists = { self.available, self.active }
    self.cursor = self.active
end

function SelectScene:_list(spec)
    local list = ScrollList.new({
        renderer = self.renderer,
        rowHeight = config.row.height,
        emptyText = spec.empty,
        emptyFont = constants.ui.back.font,
        drawRow = function(...) self:_drawRow(...) end
    })
    list.title = spec.title
    return list
end

function SelectScene:_layout()
    local w, h = love.graphics.getDimensions()
    local width = math.min(config.width, w - config.margin * 2)
    local panel = (width - config.gap) / 2
    local left = (w - width) / 2
    local top = h * config.top.ratio + config.header.height

    self.available:place(left, top, panel, h - config.margin - top)
    self.active:place(left + panel + config.gap, top, panel, h - config.margin - top)
    self.folder:place(w - self.spec.folder.margin - self.spec.folder.size, self.spec.folder.margin)
end

function SelectScene:_issue(item)
    if item.error then return string.format(self.spec.text.error, item.error), colors.danger end
    return item.warning, colors.warning
end

function SelectScene:_free(list)
    local count = 0
    for _, item in ipairs(list.items) do
        if not item.locked then count = count + 1 end
    end
    return count
end

function SelectScene:_focus(list, index)
    local count = #list.items

    for _, each in ipairs(self.lists) do
        each:select(each == list and count > 0 and utils.clamp(index, 1, count) or nil)
    end
    self.cursor = list
end

function SelectScene:_refresh()
    local current = self.cursor:current()
    local active, available = self.source:scan()

    for _, items in ipairs({ active, available }) do
        for _, item in ipairs(items) do
            item.issue, item.tint = self:_issue(item)
        end
    end
    self.active:setItems(active)
    self.available:setItems(available)

    self:_focus(#active > 0 and self.active or self.available, 1)
    for _, list in ipairs(self.lists) do
        for index, item in ipairs(list.items) do
            if current and item.folder == current.folder then self:_focus(list, index) end
        end
    end
end

function SelectScene:_commit(list, index)
    for _, each in ipairs(self.lists) do
        each:setItems(each.items)
    end
    self:_focus(list, index)
    self.source:save(self.active.items)
end

function SelectScene:_move(source, index, target, slot)
    local item = source.items[index]
    if item.locked or target == self.active and not item.id then return end

    Audio.play("click")
    table.remove(source.items, index)
    if target == source and slot and slot > index then slot = slot - 1 end

    item.enabled = target == self.active
    table.insert(target.items, math.min(slot or math.huge, self:_free(target) + 1), item)
    if target == self.available then table.sort(target.items, byName) end

    self:_commit(target, utils.indexOf(target.items, item))
end

function SelectScene:_send()
    local list, index = self.cursor, self.cursor.selected
    if not index then return end

    self:_move(list, index, list == self.active and self.available or self.active)
    if #list.items > 0 then self:_focus(list, index) end
end

function SelectScene:_shift(step)
    local list, index = self.active, self.active.selected
    local neighbor = index and list.items[index + step]
    if self.cursor ~= list or not neighbor or neighbor.locked then return end

    self:_move(list, index, list, step > 0 and index + 2 or index - 1)
end

function SelectScene:_exit()
    if self.spec.reload and self.source:changed() then return self.manager:run(Game.reload, self.spec.reload) end

    self.manager:switch(self.exit.scene, self.exit.data)
end

function SelectScene:_listAt(x, y)
    for _, list in ipairs(self.lists) do
        if utils.inside(x, y, list.x, list.y, list.width, list.height) then return list end
    end
end

function SelectScene:_slot(list, y)
    for index = 1, #list.items do
        local _, top, _, height = list:bounds(index)
        if y < top + height / 2 then return index end
    end
    return #list.items + 1
end

function SelectScene:_dragged()
    return self.drag and self.drag.active and self.drag
end

function SelectScene:_scroll(list, y, dt)
    local edge, speed = motion.edge, motion.speed * dt

    if y < list.y + edge then
        list:wheelmoved(speed)
    elseif y > list.y + list.height - edge then
        list:wheelmoved(-speed)
    end
end

function SelectScene:_hole(list)
    local drag = self:_dragged()
    if not (drag and list.target) then return end
    if list == self.active then return math.min(self:_slot(list, select(2, love.mouse.getPosition())), self:_free(list) + 1) end

    for index, item in ipairs(list.items) do
        if item ~= drag.item and byName(drag.item, item) then return index end
    end
    return #list.items + 1
end

function SelectScene:_follow(drag, dt)
    local mx, my = love.mouse.getPosition()
    Lift.follow(drag.card, mx - drag.grab.x, my - drag.grab.y, dt)
end

function SelectScene:_settle(dt)
    if not Lift.land(self.settle.landing, dt) then self.settle = nil end
end

function SelectScene:_drawHeader(list)
    local header = config.header
    local font = self.renderer:font(header.font)
    local count = tostring(#list.items)
    local y = list.y - header.gap - font:getHeight()

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, list.target and 1 or 0.8))
    love.graphics.print(list.title, list.x, y)
    love.graphics.setColor(utils.fromHex(colors.muted))
    love.graphics.print(count, list.x + list.width - font:getWidth(count), y)
end

function SelectScene:_drawContent(item, x, y, width, height, hover)
    local row = config.row
    local nameFont, detailFont = self.renderer:font(row.font.name), self.renderer:font(row.font.detail)
    local order = utils.indexOf(self.active.items, item)
    local number = order and tostring(order)
    local textX = x + row.pad + row.icon + row.gap
    local textWidth = x + width - row.pad - textX - (order and row.badge or 0)
    local right = x + width - row.pad
    local version = item.version and "v" .. item.version

    local detail = item.issue or item.locked or item.author and string.format(self.spec.text.author, item.author) or ""
    local detailWidth = right - textX - (version and detailFont:getWidth(version) + row.gap or 0)
    local _, wrapped = detailFont:getWrap(detail, detailWidth)
    local count = detail == "" and 0 or math.min(#wrapped, row.lines)
    local block = nameFont:getHeight() + (count > 0 and row.lineGap + detailFont:getHeight() * count or 0)
    local lineY = y + (height - block) / 2

    Avatar.draw(self.renderer, item.icon, item.name, x + row.pad, y + (height - row.icon) / 2, row.icon)

    love.graphics.setFont(nameFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * hover))
    utils.printFitted(item.name, textX, lineY, textWidth)

    if count > 0 then
        love.graphics.setFont(detailFont)
        love.graphics.setColor(utils.fromHex(item.issue and item.tint or colors.white, item.issue and 0.9 or 0.5))
        love.graphics.print(table.concat(wrapped, "\n", 1, count), textX, lineY + nameFont:getHeight() + row.lineGap)
    end

    love.graphics.setFont(detailFont)
    love.graphics.setColor(utils.fromHex(colors.muted))
    if version then love.graphics.print(version, right - detailFont:getWidth(version), y + height - row.pad - detailFont:getHeight()) end
    if number then love.graphics.print(number, right - detailFont:getWidth(number), y + row.pad) end
end

function SelectScene:_drawRow(item, x, y, width, height, hover, selected)
    self:_drawContent(item, x, y, width, height, selected and 1 or hover)
end

function SelectScene:_drawCard(item, state, width, height)
    Lift.draw(state, width, height,
        function(offset, alpha) Panel.fill(offset, offset, width, height, 0x000000, alpha) end,
        function()
            Panel.draw(0, 0, width, height, { alpha = 1 })
            self:_drawContent(item, 0, 0, width, height, 1)
        end)
end

function SelectScene:_drawDrag()
    local drag = self:_dragged()
    if not drag then return end

    local _, _, width, height = drag.list:bounds(drag.index)
    self:_drawCard(drag.item, drag.card, width, height)
end

function SelectScene:_drawSettle()
    local settle = self.settle
    if not settle then return end

    for _, list in ipairs(self.lists) do
        local index = utils.indexOf(list.items, settle.item)
        if index then
            local x, y, width, height = list:bounds(index)
            self:_drawCard(settle.item, Lift.at(settle.landing, x, y), width, height)
        end
    end
end

function SelectScene:_drawTooltip()
    local mx, my = love.mouse.getPosition()
    if self.folder:contains(mx, my) then return self.folder:drawTooltip(self.tooltip) end

    local list = self:_listAt(mx, my)
    local item = list and list.items[list:rowAt(mx, my)]
    local info = item and (item.issue or item.description)
    if info and info ~= "" then self.tooltip:draw(item.name, info) end
end

function SelectScene:enter(_, data)
    self.exit = data and data.back or { scene = "options" }
    self.drag, self.settle = nil, nil
    self.toast:clear()
    for _, list in ipairs(self.lists) do
        list:resetScroll()
    end
    self:_layout()
    self:_refresh()
end

function SelectScene:update(dt)
    self:_layout()
    self.background:update(dt)
    self.back:update(dt)
    self.folder:update(dt)
    self.toast:update(dt)

    local mx, my = love.mouse.getPosition()
    local drag = self:_dragged()
    local target = drag and self:_listAt(mx, my)

    if drag then self:_follow(drag, dt) end
    if self.settle then self:_settle(dt) end

    local held = drag or self.settle
    for _, list in ipairs(self.lists) do
        list.held = held and held.item
        list.target = target == list
        list:setHole(self:_hole(list), drag and drag.list == list and drag.index or nil)
        list:update(dt, not drag)
    end
    if target then self:_scroll(target, my, dt) end
end

function SelectScene:mousepressed(x, y, button)
    if button ~= 1 then return end

    if self.back:hit(x, y) then return self:_exit() end
    if self.folder:hit(x, y) then return self.source:open() end

    for _, list in ipairs(self.lists) do
        if list:mousepressed(x, y, button) then return end

        local index = list:rowAt(x, y)
        if index then
            local left, top = list:bounds(index)
            local item = list.items[index]

            self:_focus(list, index)
            if item.locked then return end

            self.drag = {
                list = list,
                index = index,
                item = item,
                card = Lift.new(left, top),
                press = { x = x, y = y },
                grab = { x = x - left, y = y - top }
            }
            return
        end
    end
end

function SelectScene:mousemoved(x, y)
    for _, list in ipairs(self.lists) do
        list:mousemoved(x, y)
    end

    local drag = self.drag
    if drag and math.abs(x - drag.press.x) + math.abs(y - drag.press.y) > motion.threshold then
        drag.active = true
    end
end

function SelectScene:mousereleased(x, y, button)
    for _, list in ipairs(self.lists) do
        list:mousereleased()
    end

    local drag = self.drag
    self.drag = nil
    if button ~= 1 or not drag then return end

    if not drag.active then
        return self:_move(drag.list, drag.index, drag.list == self.active and self.available or self.active)
    end

    local target = self:_listAt(x, y)
    if target then self:_move(drag.list, drag.index, target, target == self.active and self:_slot(target, y) or nil) end
    self.settle = { item = drag.item, landing = Lift.release(drag.card) }
end

function SelectScene:wheelmoved(_, y)
    local list = self:_listAt(love.mouse.getPosition())
    if list then list:wheelmoved(y) end
end

function SelectScene:filedropped(file)
    local id, err = self.source:install(file)
    if not id then return self.toast:show(err, true) end

    self:_refresh()
    self.toast:show(string.format(self.spec.text.installed, id))
end

function SelectScene:focus(focused)
    if focused then self:_refresh() end
end

function SelectScene:keypressed(key)
    if key == "escape" then
        if self.drag then self.drag = nil else self:_exit() end
    elseif steps[key] and love.keyboard.isDown("lshift", "rshift") then
        self:_shift(steps[key])
    elseif steps[key] then
        self.cursor:move(steps[key])
    elseif sides[key] then
        local list = self[sides[key]]
        if #list.items > 0 then self:_focus(list, self.cursor.selected or 1) end
    elseif key == "return" or key == "kpenter" or key == "space" then
        self:_send()
    end
end

function SelectScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    for _, list in ipairs(self.lists) do
        self:_drawHeader(list)
        list:draw()
    end
    self.back:draw()
    self.folder:draw()
    self:_drawDrag()
    self:_drawSettle()
    self.toast:draw(love.graphics.getHeight() - config.margin * 2)
    if not self:_dragged() then self:_drawTooltip() end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return SelectScene
