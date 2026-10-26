local IconButton = require("src/ui/widgets/IconButton")
local ScrollList = require("src/ui/widgets/ScrollList")
local TextField = require("src/ui/widgets/TextField")
local Panel = require("src/ui/Panel")
local Shine = require("src/ui/decor/Shine")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.library
local colors = constants.ui.colors

local titles = {}
for _, category in ipairs(constants.registry.categories) do
    titles[category.id] = category.title
end

local function categoryLine(class)
    local names = {}
    for _, category in ipairs(class.categories) do
        names[#names + 1] = titles[category]
    end
    return table.concat(names, " / ")
end

local sorts = {}

function sorts.name(a, b)
    return a.title:lower() < b.title:lower()
end

function sorts.nameDesc(a, b)
    return sorts.name(b, a)
end

function sorts.category(a, b)
    if a.category ~= b.category then return a.category < b.category end
    return sorts.name(a, b)
end

function sorts.subtick(a, b)
    local x, y = a.subtick[1] or math.huge, b.subtick[1] or math.huge
    if x ~= y then return x < y end
    return sorts.name(a, b)
end

local function rank(text, word)
    if text == word then return 0 end
    if text:sub(1, #word) == word then return 1 end
    if text:find(" " .. word, 1, true) then return 2 end
    if text:find(word, 1, true) then return 3 end
end

local function addBox(x, y, width, height)
    local size = config.row.add
    return x + width - size - config.row.pad, y + (height - size) / 2, size
end

local Library = {}
Library.__index = Library

function Library.new(data)
    local self = setmetatable({}, Library)
    self.renderer = data.renderer
    self.registry = data.registry
    self.toolbar = data.toolbar
    self.fresh = data.fresh
    self.onPick = data.onPick
    self.tooltip = Tooltip.new(data.renderer)
    self.active = false
    self.menu = false
    self.menuT = 0
    self.box = {}
    self.sort = config.sorts[1].id
    self.category = "all"
    self.all = {}

    self.search = TextField.new({ renderer = data.renderer, placeholder = config.placeholder })
    self.filter = IconButton.new({
        renderer = data.renderer,
        texture = "filter",
        size = config.filter.size,
        title = config.filter.title,
        description = config.filter.description
    })
    self.categories = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.category.height,
        drawRow = function(...) self:_drawCategory(...) end
    })
    self.cells = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.row.height,
        emptyText = config.empty,
        emptyFont = config.category.font,
        drawRow = function(...) self:_drawCell(...) end
    })
    self.sorts = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.sort.height,
        drawRow = function(...) self:_drawSort(...) end
    })
    return self
end

function Library:_layout()
    local w, h = love.graphics.getDimensions()
    local box, pad, gap = self.box, config.pad, config.gap
    local filter = config.filter.size

    box.width, box.height = math.min(config.width, w - config.margin * 2), math.min(config.height, h - config.margin * 2)
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2

    local top = box.y + pad
    self.search:place(box.x + pad, top, box.width - pad * 2 - gap - filter)
    self.filter:place(box.x + box.width - pad - filter, top)

    local bodyY = top + filter + gap
    local bodyHeight = box.y + box.height - pad - bodyY
    local listX = box.x + pad + config.sidebar + gap
    self.categories:place(box.x + pad, bodyY, config.sidebar, bodyHeight)
    self.cells:place(listX, bodyY, box.x + box.width - pad - listX, bodyHeight)

    local sort = config.sort
    self.sorts:place(self.filter.x + filter - sort.width, self.filter.y + filter + gap - (1 - self.menuT) * sort.slide,
        sort.width, #config.sorts * sort.height + constants.ui.list.pad * 2)
end

function Library:_load()
    local counts = {}
    self.all = self.registry:list()
    for _, class in ipairs(self.all) do
        for _, category in ipairs(class.categories) do
            counts[category] = (counts[category] or 0) + 1
        end
    end

    local items = {
        {
            id = "all",
            title = config.all.title,
            icon = config.all.icon,
            count = #self.all
        }
    }
    for _, category in ipairs(constants.registry.categories) do
        if counts[category.id] then
            items[#items + 1] = {
                id = category.id,
                title = category.title,
                icon = category.icon,
                folder = category.folder,
                count = counts[category.id]
            }
        end
    end
    self.categories:setItems(items, 1)

    for index, sort in ipairs(config.sorts) do
        if sort.id == self.sort then self.sorts:setItems(config.sorts, index) end
    end
    self:_refresh()
end

function Library:_score(class)
    local total = 0
    for word in self.search.text:lower():gmatch("%S+") do
        local title, name = rank(class.title:lower(), word), rank(class.name:lower(), word)
        if not (title or name) then return end
        total = total + math.min(title or 3, name or 3)
    end
    return total
end

function Library:_refresh()
    local items, scores = {}, {}
    for _, class in ipairs(self.all) do
        local score = self:_score(class)
        if score and (self.category == "all" or utils.has(class.categories, self.category)) then
            items[#items + 1] = class
            scores[class] = score
        end
    end

    table.sort(items, function(a, b)
        if scores[a] ~= scores[b] then return scores[a] < scores[b] end
        return sorts[self.sort](a, b)
    end)
    self.cells:setItems(items, 1)
    self.cells:resetScroll()
end

function Library:_shiftCategory(step)
    local list = self.categories
    local index = utils.clamp((list.selected or 1) + step, 1, #list.items)
    if index == list.selected then return end

    list:select(index)
    self.category = list.items[index].id
    self:_refresh()
end

function Library:_pick(class)
    self:close()
    self.onPick(class)
end

function Library:_drawCategory(category, x, y, width, height, hover, selected)
    local style = config.category
    local font = self.renderer:font(style.font)
    local countFont = self.renderer:font(style.count.font)
    local icon = self.renderer.textures[category.folder or "cells"][category.icon]
    local scale = style.icon / icon:getWidth()
    local alpha = selected and 1 or 0.7 + 0.3 * hover
    local count = tostring(category.count)
    local countWidth = countFont:getWidth(count)
    local textX = x + style.inset + style.icon + style.gap

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(icon, x + style.inset, y + (height - style.icon) / 2, 0, scale, scale)

    love.graphics.setFont(font)
    utils.printFitted(category.title, textX, y + (height - font:getHeight()) / 2,
        x + width - style.inset - countWidth - style.gap - textX)

    love.graphics.setFont(countFont)
    love.graphics.setColor(utils.fromHex(colors.white, style.count.alpha))
    love.graphics.print(count, x + width - style.inset - countWidth, y + (height - countFont:getHeight()) / 2)
end

function Library:_drawSort(sort, x, y, width, height, _, selected)
    local font = self.renderer:font(config.sort.font)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, (selected and 1 or 0.7) * self.sorts.fade))
    love.graphics.print(sort.title, x + config.sort.inset, y + (height - font:getHeight()) / 2)
end

function Library:_drawCell(class, x, y, width, height)
    local row = config.row
    local texture = self.renderer.textures.cells[class.texture]
    local tw, th = texture:getDimensions()
    local scale = row.icon / tw
    local titleFont = self.renderer:font(row.font.title)
    local categoryFont = self.renderer:font(row.font.category)
    local textY = y + (height - titleFont:getHeight() - categoryFont:getHeight()) / 2
    local textX = x + row.pad * 2 + row.icon

    love.graphics.setColor(utils.fromHex(colors.white))
    Shine.set(self.fresh:has(class))
    love.graphics.draw(texture, x + row.pad, y + (height - row.icon) / 2, 0, scale, scale)
    Shine.set(false)

    love.graphics.setFont(titleFont)
    love.graphics.print(class.title, textX, textY)
    love.graphics.setFont(categoryFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.5))
    love.graphics.print(categoryLine(class), textX, textY + titleFont:getHeight())

    local bx, by, size = addBox(x, y, width, height)
    local icon = self.renderer.textures.ui[self.toolbar:has(class) and "subtract" or "add"]
    local alpha = utils.inside(love.mouse.getX(), love.mouse.getY(), bx, by, size, size) and 1 or 0.6

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(icon, bx, by, 0, size / icon:getWidth(), size / icon:getHeight())
end

function Library:_drawTooltip()
    local mx, my = love.mouse.getPosition()
    local index = not self.menu and self.cells:rowAt(mx, my)

    if index then
        local class = self.cells.items[index]
        local bx, by, size = addBox(self.cells:bounds(index))

        if not utils.inside(mx, my, bx, by, size, size) then
            self.tooltip:draw(class.title, class.description)
        else
            local text = self.toolbar:has(class) and config.remove or config.add
            self.tooltip:draw(text.title, text.description)
        end
    end
    self.filter:drawTooltip(self.tooltip)
end

function Library:_click(x, y)
    local category = self.categories:rowAt(x, y)
    if category then
        Audio.play("click")
        self.categories:select(category)
        self.category = self.categories.items[category].id
        return self:_refresh()
    end

    local index = self.cells:rowAt(x, y)
    if not index then return end

    Audio.play("click")
    local class = self.cells.items[index]
    self.fresh:clear(class)
    local bx, by, size = addBox(self.cells:bounds(index))
    if utils.inside(x, y, bx, by, size, size) or love.keyboard.isDown("lshift", "rshift") then
        self.toolbar:toggle(class)
    else
        self:_pick(class)
    end
end

function Library:open()
    self.active = true
    self.menu = false
    self.menuT = 0
    self.category = "all"
    self.search:set("")
    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
    
    self:_layout()
    self.categories:resetScroll()
    self.cells:resetScroll()
    self:_load()
end

function Library:close()
    self.active = false
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function Library:update(dt)
    if not self.active then return end

    self.menuT = utils.lerp(self.menuT, self.menu and 1 or 0, math.min(1, config.sort.speed * dt))
    if math.abs(self.menuT - (self.menu and 1 or 0)) < 0.01 then self.menuT = self.menu and 1 or 0 end
    self.sorts.fade = self.menuT

    self:_layout()
    self.search:update(dt)
    self.filter:update(dt)
    self.categories:update(dt, not self.menu)
    self.cells:update(dt, not self.menu)
    self.sorts:update(dt, self.menu)
end

function Library:mousepressed(x, y, button)
    if not self.active then return false end
    self:_layout()
    if button ~= 1 then return true end

    local box = self.box
    if self.menu then
        local index = self.sorts:rowAt(x, y)
        if index then
            Audio.play("click")
            self.sort = config.sorts[index].id
            self.sorts:select(index)
            self:_refresh()
        end
        self.menu = false
    elseif not utils.inside(x, y, box.x, box.y, box.width, box.height) then
        self:close()
    elseif self.filter:hit(x, y) then
        self.menu = true
    elseif not (self.cells:mousepressed(x, y, button) or self.categories:mousepressed(x, y, button)) then
        self:_click(x, y)
    end
    return true
end

function Library:mousemoved(x, y)
    self.cells:mousemoved(x, y)
    self.categories:mousemoved(x, y)
end

function Library:mousereleased()
    self.cells:mousereleased()
    self.categories:mousereleased()
end

function Library:keypressed(key)
    if not self.active then return false end

    if key == "escape" or key == "tab" then
        self:close()
    elseif key == "return" or key == "kpenter" then
        local class = self.cells:current() or self.cells.items[1]
        if class then self:_pick(class) end
    elseif key == "up" then
        self.cells:move(-1)
    elseif key == "down" then
        self.cells:move(1)
    elseif key == "left" then
        self:_shiftCategory(-1)
    elseif key == "right" then
        self:_shiftCategory(1)
    elseif self.search:keypressed(key) then
        self:_refresh()
    end
    return true
end

function Library:textinput(text)
    if self.active and self.search:textinput(text) then self:_refresh() end
end

function Library:wheelmoved(_, y)
    if not self.active then return false end

    local mx, my = love.mouse.getPosition()
    local sidebar = self.categories
    local over = utils.inside(mx, my, sidebar.x, sidebar.y, sidebar.width, sidebar.height)
    local list = over and sidebar or self.cells
    list:wheelmoved(y)
    return true
end

function Library:draw()
    if not self.active then return end

    self:_layout()
    local w, h = love.graphics.getDimensions()
    local box = self.box
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    self.search:draw()
    self.filter:draw()
    self.categories:draw()
    self.cells:draw()
    if self.menuT > 0 then self.sorts:draw() end
    self:_drawTooltip()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Library
