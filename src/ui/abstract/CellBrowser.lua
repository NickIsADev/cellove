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
local syntax = config.search
local colors = constants.ui.colors

local titles = {}
for _, category in ipairs(constants.registry.categories) do
    titles[category.id] = category.title
end

local function categoryLine(class)
    local names = {}
    for _, category in ipairs(class.lineage) do
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

local filters = {}

function filters.text(class, word)
    local title, name = rank(class.title:lower(), word), rank(class.name:lower(), word)
    if title or name then return math.min(title or 3, name or 3) end
end

function filters.id(class, value)
    local id = tonumber(value)
    return id and rawget(class, "k3") == id and 0
end

function filters.description(class, word)
    return rank(class.description:lower(), word)
end

function filters.category(class, word)
    for _, category in ipairs(class.lineage) do
        local found = rank(category, word) or rank(titles[category]:lower(), word)
        if found then return found end
    end
end

function filters.subtick(class, value)
    return utils.has(class.subtick, tonumber(value)) and 0
end

function filters.exact(class, word)
    return (class.title:lower() == word or class.name:lower() == word) and 0
end

local function parse(query)
    local terms = {}

    for word in query:gmatch("%S+") do
        local negated = word:sub(1, 1) == syntax.negate
        local body = negated and word:sub(2) or word
        local kind = syntax.symbols[body:sub(1, 1)]
        local last = terms[#terms]

        if not (kind or negated) and last and syntax.phrases[last.kind] then
            last.value = utils.trim(last.value .. " " .. word)
        else
            terms[#terms + 1] = { negated = negated, kind = kind or "text", value = kind and body:sub(2) or body }
        end
    end
    return terms
end

local function match(class, term)
    if term.value == "" then return 0 end

    local score = filters[term.kind](class, term.value)
    if term.negated then return not score and 0 end
    return score
end

local function listed(class, entry)
    if entry.id == "all" then return true end
    return utils.has(entry.direct and class.categories or class.lineage, entry.id)
end

local CellBrowser = {}
CellBrowser.__index = CellBrowser

function CellBrowser:setup(data)
    self.renderer = data.renderer
    self.onPick = data.onPick
    self.tooltip = Tooltip.new(data.renderer)
    self.active = false
    self.menu = false
    self.menuT = 0
    self.box = {}
    self.sort = config.sorts[1].id
    self.all = {}

    self.search = TextField.new({ renderer = data.renderer, placeholder = config.placeholder })
    self.filter = IconButton.new({
        id = "filter",
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

    self.tools = { self.filter }
    self.actions = { filter = self._openSorts }
end

function CellBrowser:_layout()
    local w, h = love.graphics.getDimensions()
    local box, pad, gap = self.box, config.pad, config.gap
    local filter = config.filter.size

    box.width, box.height = math.min(config.width, w - config.margin * 2), math.min(config.height, h - config.margin * 2)
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2

    local top = box.y + pad
    local right = box.x + box.width - pad
    for _, tool in ipairs(self.tools) do
        tool:place(right - tool.width, top)
        right = right - tool.width - gap
    end
    self.search:place(box.x + pad, top, right - box.x - pad)

    local bodyY = top + filter + gap
    local bodyHeight = box.y + box.height - pad - bodyY
    local listX = box.x + pad + config.sidebar + gap
    self.categories:place(box.x + pad, bodyY, config.sidebar, bodyHeight)
    self.cells:place(listX, bodyY, box.x + box.width - pad - listX, bodyHeight)

    local sort = config.sort
    self.sorts:place(self.filter.x + filter - sort.width, self.filter.y + filter + gap - (1 - self.menuT) * sort.slide,
        sort.width, #config.sorts * sort.height + constants.ui.list.pad * 2)
end

function CellBrowser:_load(classes)
    local counts = {}
    self.all = classes
    for _, class in ipairs(self.all) do
        for _, category in ipairs(class.lineage) do
            counts[category] = (counts[category] or 0) + 1
        end
    end

    self.entries = {
        all = {
            id = "all",
            title = config.all.title,
            icon = config.all.icon,
            count = #self.all
        }
    }
    self.roots = {}
    for _, category in ipairs(constants.registry.categories) do
        if counts[category.id] then
            self.entries[category.id] = {
                id = category.id,
                title = category.title,
                icon = category.icon,
                folder = category.folder,
                parent = category.parent,
                count = counts[category.id],
                children = {}
            }
        end
    end
    for _, category in ipairs(constants.registry.categories) do
        local entry = self.entries[category.id]
        local list = entry and (entry.parent and self.entries[entry.parent].children or self.roots)
        if list then list[#list + 1] = entry end
    end
    for _, root in ipairs(self.roots) do
        local own = {
            id = root.id,
            title = root.title,
            icon = root.icon,
            folder = root.folder,
            parent = root.id,
            direct = true,
            count = 0
        }
        for _, class in ipairs(self.all) do
            if listed(class, own) then own.count = own.count + 1 end
        end
        if #root.children > 0 and own.count > 0 then root.own = own end
    end

    for index, sort in ipairs(config.sorts) do
        if sort.id == self.sort then self.sorts:setItems(config.sorts, index) end
    end
    self:_setCategory(self.entries.all)
end

function CellBrowser:_setCategory(entry)
    local rows = { self.entries.all }

    for _, root in ipairs(self.roots) do
        rows[#rows + 1] = root
        if root.id == entry.id or root.id == entry.parent then
            rows[#rows + 1] = root.own
            for _, child in ipairs(root.children) do rows[#rows + 1] = child end
        end
    end

    self.entry = entry
    self.categories:setItems(rows, utils.indexOf(rows, entry))
    self:_refresh()
end

function CellBrowser:_score(class, terms)
    local total = 0
    for _, term in ipairs(terms) do
        local score = match(class, term)
        if not score then return end
        total = total + score
    end
    return total
end

function CellBrowser:_refresh()
    local items, scores = {}, {}
    local terms = parse(self.search.text:lower())
    for _, class in ipairs(self.all) do
        local score = self:_score(class, terms)
        if score and listed(class, self.entry) then
            items[#items + 1] = class
            scores[class] = score
        end
    end

    table.sort(items, function(a, b)
        if scores[a] ~= scores[b] then return scores[a] < scores[b] end
        return sorts[self.sort](a, b)
    end)

    local index = utils.indexOf(items, self.current)
    self.cells:setItems(items, index or 1)
    if not index then self.cells:resetScroll() end
end

function CellBrowser:_typed()
    self.current = nil
    self:_refresh()
end

function CellBrowser:_openSorts()
    self.menu = true
end

function CellBrowser:_tool(x, y)
    for _, tool in ipairs(self.tools) do
        if tool:hit(x, y) then return tool end
    end
end

function CellBrowser:_shiftCategory(step)
    local list = self.categories
    local index = utils.clamp((list.selected or 1) + step, 1, #list.items)
    if index ~= list.selected then self:_setCategory(list.items[index]) end
end

function CellBrowser:_pick(class)
    self:close()
    self.onPick(class)
end

function CellBrowser:_drawCategory(category, x, y, width, height, hover, selected)
    local style = config.category
    local font = self.renderer:font(style.font)
    local countFont = self.renderer:font(style.count.font)
    local icon = self.renderer.textures[category.folder or "cells"][category.icon]
    local scale = style.icon / icon:getWidth()
    local alpha = selected and 1 or 0.7 + 0.3 * hover
    local count = tostring(category.count)
    local countWidth = countFont:getWidth(count)
    local left = x + style.inset + (category.parent and style.indent or 0)
    local textX = left + style.icon + style.gap

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(icon, left, y + (height - style.icon) / 2, 0, scale, scale)

    love.graphics.setFont(font)
    utils.printFitted(category.title, textX, y + (height - font:getHeight()) / 2,
        x + width - style.inset - countWidth - style.gap - textX)

    love.graphics.setFont(countFont)
    love.graphics.setColor(utils.fromHex(colors.white, style.count.alpha))
    love.graphics.print(count, x + width - style.inset - countWidth, y + (height - countFont:getHeight()) / 2)
end

function CellBrowser:_drawSort(sort, x, y, width, height, _, selected)
    local font = self.renderer:font(config.sort.font)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, (selected and 1 or 0.7) * self.sorts.fade))
    love.graphics.print(sort.title, x + config.sort.inset, y + (height - font:getHeight()) / 2)
end

function CellBrowser:_shines()
    return false
end

function CellBrowser:_drawExtras() end

function CellBrowser:_describe(class)
    return class.title, class.description
end

function CellBrowser:_choose(class)
    self:_pick(class)
end

function CellBrowser:_drawCell(class, x, y, width, height)
    local row = config.row
    local texture = self.renderer.textures.cells[class.texture]
    local tw, th = texture:getDimensions()
    local scale = row.icon / tw
    local titleFont = self.renderer:font(row.font.title)
    local categoryFont = self.renderer:font(row.font.category)
    local textY = y + (height - titleFont:getHeight() - categoryFont:getHeight()) / 2
    local textX = x + row.pad * 2 + row.icon

    love.graphics.setColor(utils.fromHex(colors.white))
    Shine.set(self:_shines(class))
    love.graphics.draw(texture, x + row.pad, y + (height - row.icon) / 2, 0, scale, scale)
    Shine.set(false)

    love.graphics.setFont(titleFont)
    love.graphics.print(class.title, textX, textY)
    love.graphics.setFont(categoryFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.5))
    love.graphics.print(categoryLine(class), textX, textY + titleFont:getHeight())
    self:_drawExtras(class, x, y, width, height)
end

function CellBrowser:_drawTooltip()
    local mx, my = love.mouse.getPosition()
    local index = not self.menu and self.cells:rowAt(mx, my)

    if index then self.tooltip:draw(self:_describe(self.cells.items[index], index, mx, my)) end
    for _, tool in ipairs(self.tools) do tool:drawTooltip(self.tooltip) end
end

function CellBrowser:_click(x, y)
    local category = self.categories:rowAt(x, y)
    if category then
        Audio.play("click")
        return self:_setCategory(self.categories.items[category])
    end

    local index = self.cells:rowAt(x, y)
    if not index then return end

    Audio.play("click")
    self:_choose(self.cells.items[index], index, x, y)
end

function CellBrowser:open(classes)
    self.active = true
    self.menu = false
    self.menuT = 0
    self.search:set("")
    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)

    self:_layout()
    self.categories:resetScroll()
    self.cells:resetScroll()
    self:_load(classes)
end

function CellBrowser:close()
    self.active = false
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function CellBrowser:update(dt)
    if not self.active then return end

    self.menuT = utils.lerp(self.menuT, self.menu and 1 or 0, math.min(1, config.sort.speed * dt))
    if math.abs(self.menuT - (self.menu and 1 or 0)) < 0.01 then self.menuT = self.menu and 1 or 0 end
    self.sorts.fade = self.menuT

    self:_layout()
    self.search:update(dt)
    for _, tool in ipairs(self.tools) do tool:update(dt) end
    self.categories:update(dt, not self.menu)
    self.cells:update(dt, not self.menu)
    self.sorts:update(dt, self.menu)
end

function CellBrowser:mousepressed(x, y, button)
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
    else
        local tool = self:_tool(x, y)
        if tool then
            self.actions[tool.id](self)
        elseif not (self.cells:mousepressed(x, y, button) or self.categories:mousepressed(x, y, button)) then
            self:_click(x, y)
        end
    end
    return true
end

function CellBrowser:mousemoved(x, y)
    self.cells:mousemoved(x, y)
    self.categories:mousemoved(x, y)
end

function CellBrowser:mousereleased()
    self.cells:mousereleased()
    self.categories:mousereleased()
end

function CellBrowser:keypressed(key)
    if not self.active then return false end

    if key == "escape" then
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
        self:_typed()
    end
    return true
end

function CellBrowser:textinput(text)
    if self.active and self.search:textinput(text) then self:_typed() end
end

function CellBrowser:wheelmoved(_, y)
    if not self.active then return false end

    local mx, my = love.mouse.getPosition()
    local sidebar = self.categories
    local over = utils.inside(mx, my, sidebar.x, sidebar.y, sidebar.width, sidebar.height)
    local list = over and sidebar or self.cells
    list:wheelmoved(y)
    return true
end

function CellBrowser:draw()
    if not self.active then return end

    self:_layout()
    local w, h = love.graphics.getDimensions()
    local box = self.box
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    self.search:draw()
    for _, tool in ipairs(self.tools) do tool:draw() end
    self.categories:draw()
    self.cells:draw()
    if self.menuT > 0 then self.sorts:draw() end
    self:_drawTooltip()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return CellBrowser
