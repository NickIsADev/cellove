local Widget = require("src/ui/abstract/Widget")
local IconButton = require("src/ui/widgets/IconButton")
local Panel = require("src/ui/Panel")
local Lift = require("src/ui/decor/Lift")
local Shine = require("src/ui/decor/Shine")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.toolbar
local tools = constants.editor.tools
local colors = constants.ui.colors

local function button(renderer, spec, rotation)
    return IconButton.new({
        renderer = renderer,
        id = spec.id,
        texture = spec.texture,
        size = config.slot,
        rotation = rotation,
        title = spec.title,
        description = spec.description
    })
end

local Toolbar = {}
Toolbar.__index = Toolbar

function Toolbar.new(data)
    local self = setmetatable({}, Toolbar)
    self.renderer = data.renderer
    self.registry = data.registry
    self.settings = data.settings
    self.fresh = data.fresh
    self.on = data.on
    self.tooltip = Tooltip.new(data.renderer)
    self.items = {}
    self.history = {}
    self.xs = {}
    self.hover = {}
    self.page = 1
    self.flip = 0
    self.open = false
    self.reveal = 0

    self.picker = button(data.renderer, config.picker)
    self.library = button(data.renderer, config.library)
    self.prev = button(data.renderer, config.arrow, math.pi)
    self.next = button(data.renderer, config.arrow)

    data.settings:listen("toolbar", function(layout) self:_parse(layout) end)
    self:_migrate()
    return self
end

function Toolbar:_migrate()
    for _, id in ipairs(config.layout) do
        local class = self.registry.cells[id]
        if class and self.fresh:has(class) then self:add(class) end
    end
end

function Toolbar:_parse(layout)
    self.items = {}
    for id in layout:gmatch("[^,]+") do
        local class = self.registry.cells[id]
        if class then self.items[#self.items + 1] = class end
    end
end

function Toolbar:_store()
    local ids = {}
    for _, class in ipairs(self.items) do
        ids[#ids + 1] = class.id
    end
    self.settings:set("toolbar", table.concat(ids, ","))
end

function Toolbar:_reserve()
    return config.gap + config.slot + config.pad
end

function Toolbar:_remember(class)
    local index = utils.indexOf(self.history, class)

    if index then table.remove(self.history, index) end
    table.insert(self.history, 1, class)
    self.history[config.history + 1] = nil
end

function Toolbar:_rowY()
    return love.graphics.getHeight() - config.height + config.margin
end

function Toolbar:_paging()
    local step = config.slot + config.pad
    local room = love.graphics.getWidth() - config.start - self:_reserve()
    local arrows = #self.items * step > room
    local perPage = math.max(1, math.floor((arrows and room - step * 2 or room) / step))
    local pages = math.max(1, math.ceil(#self.items / perPage))

    self.page = utils.clamp(self.page, 1, pages)
    return step, perPage, pages, arrows
end

function Toolbar:_order()
    local drag = self.drag
    if not (drag and drag.active) then return self.items end

    local order = {}
    for _, class in ipairs(self.items) do
        if class ~= drag.class then order[#order + 1] = class end
    end
    table.insert(order, utils.clamp(drag.index, 1, #order + 1), drag.class)
    return order
end

function Toolbar:_view()
    local step, perPage, pages, arrows = self:_paging()
    local y = self:_rowY()
    local first = (self.page - 1) * perPage

    local slots = {}
    for index, class in ipairs(self:_order()) do
        slots[index] = {
            class = class,
            x = config.start + (index - 1 - first) * step,
            y = y,
            shown = index > first and index <= first + perPage
        }
    end
    return {
        slots = slots,
        pages = pages,
        arrows = arrows,
        width = perPage * step
    }
end

function Toolbar:_place()
    local edge = love.graphics.getWidth() - self:_reserve()
    local step = config.slot + config.pad
    local y = self:_rowY()

    self.picker:place(config.pad, y)
    self.library:place(config.pad + step, y)
    self.prev:place(edge - step * 2, y)
    self.next:place(edge - step, y)
end

function Toolbar:_hovered()
    return not (self.drag or Widget.blocked) and self:slotAt(love.mouse.getPosition())
end

function Toolbar:_overInfo(x, y)
    return y >= love.graphics.getHeight() - config.height and x >= love.graphics.getWidth() - self:_reserve()
end

function Toolbar:_infoHovered()
    return self.selected and not Widget.blocked and self:_overInfo(love.mouse.getPosition())
end

function Toolbar:_recent()
    if self.reveal == 0 then return end

    local step, count, pop = config.slot + config.pad, #self.history, config.pop
    local box = {
        width = step + config.pad,
        height = count * step + config.pad,
        slots = {}
    }
    box.x = love.graphics.getWidth() - config.pad * 2 - config.slot
    box.y = love.graphics.getHeight() - config.height - config.gap - box.height

    for index, class in ipairs(self.history) do
        local y = box.y + box.height - index * step
        local grow = utils.clamp(self.reveal * (1 + pop.stagger * (count - 1)) - (index - 1) * pop.stagger, 0, 1)

        box.slots[index] = { class = class, x = box.x + config.pad, y = y, drawY = utils.lerp(self:_rowY(), y, grow), grow = grow }
    end
    return box
end

function Toolbar:_recentAt(x, y)
    local box = self.open and self:_recent()
    if not box then return end

    for _, slot in ipairs(box.slots) do
        if utils.inside(x, y, slot.x, slot.y, config.slot, config.slot) then return slot.class end
    end
end

function Toolbar:_flip(dt)
    local drag = self.drag
    local over = (self.prev:contains(love.mouse.getPosition()) and -1) or (self.next:contains(love.mouse.getPosition()) and 1)

    if over and drag and drag.active then
        self.flip = self.flip + dt
        if self.flip >= config.drag.flip then
            self.page = self.page + over
            self.flip = 0
        end
    else
        self.flip = 0
    end
end

function Toolbar:_track()
    local drag = self.drag
    if not (drag and drag.active) then return end

    local step, perPage = self:_paging()
    local slot = utils.clamp(math.floor((love.mouse.getX() - config.start) / step) + 1, 1, perPage)
    drag.index = (self.page - 1) * perPage + slot
end

function Toolbar:_drawSlot(slot, rotation)
    local texture = self.renderer.textures.cells[slot.class.texture]
    local tw, th = texture:getDimensions()
    local hover = self.hover[slot.class] or 0
    local scale = config.slot / tw * (1 + config.hover.growth * hover)
    local alpha = slot.class == self.selected and 1 or 0.5 + 0.25 * hover
    local x, y = (self.xs[slot.class] or slot.x) + config.slot / 2, slot.y + config.slot / 2 - config.hover.lift * hover

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    Shine.set(self.fresh:has(slot.class))
    love.graphics.draw(texture, x, y, rotation * math.pi / 2, scale, scale, tw / 2, th / 2)
    Shine.set(false)
end

function Toolbar:_icon(texture, x, y, rotation, alpha, grow)
    local tw, th = texture:getDimensions()
    local scale = config.slot / tw * (grow or 1)

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(texture, x + config.slot / 2, y + config.slot / 2, rotation * math.pi / 2, scale, scale, tw / 2, th / 2)
end

function Toolbar:_drawInfo(rotation)
    local textures = self.renderer.textures
    local texture = self.selected and textures.cells[self.selected.texture] or textures.ui.base

    self:_icon(texture, love.graphics.getWidth() - config.pad - config.slot, self:_rowY(), rotation, self.selected and 1 or 0.5)
end

function Toolbar:_drawRecent(rotation)
    local box = self:_recent()
    if not box then return end

    local hovered = not Widget.blocked and self:_recentAt(love.mouse.getPosition())

    for _, slot in ipairs(box.slots) do
        local alpha = slot.class == self.selected and 1 or slot.class == hovered and 0.75 or 0.5

        self:_icon(self.renderer.textures.cells[slot.class.texture], slot.x, slot.drawY, rotation, alpha, slot.grow)
    end
end

function Toolbar:_drawCard(class, state, rotation)
    local texture = self.renderer.textures.cells[class.texture]
    local tw, th = texture:getDimensions()
    local scale = config.slot / tw * (1 + config.hover.growth)
    local center = config.slot / 2

    Lift.draw(state, config.slot, config.slot,
        function(offset, alpha)
            love.graphics.setColor(0, 0, 0, alpha)
            love.graphics.draw(texture, center + offset, center + offset, rotation * math.pi / 2, scale, scale, tw / 2, th / 2)
        end,
        function()
            love.graphics.setColor(utils.fromHex(colors.white))
            love.graphics.draw(texture, center, center, rotation * math.pi / 2, scale, scale, tw / 2, th / 2)
        end)
end

function Toolbar:has(class)
    return utils.has(self.items, class)
end

function Toolbar:add(class)
    if self:has(class) then return end

    self.items[#self.items + 1] = class
    self:_store()
end

function Toolbar:remove(class)
    for index, item in ipairs(self.items) do
        if item == class then
            table.remove(self.items, index)
            break
        end
    end
    self:_store()
end

function Toolbar:toggle(class)
    if self:has(class) then self:remove(class) else self:add(class) end
end

function Toolbar:restore()
    self.settings:set("toolbar", self.settings.defaults.toolbar)
end

function Toolbar:setTool(id)
    for _, tool in ipairs(tools.list) do
        if tool.id == id then self.picker.texture = tool.texture end
    end
end

function Toolbar:reset()
    self.page, self.flip, self.drag, self.settle, self.open, self.reveal = 1, 0, nil, nil, false, 0
    self.xs = {}
end

function Toolbar:contains(x, y)
    local box = self.open and self:_recent()
    return y >= love.graphics.getHeight() - config.height or box and utils.inside(x, y, box.x, box.y, box.width, box.height)
end

function Toolbar:slotAt(x, y)
    for _, slot in ipairs(self:_view().slots) do
        if slot.shown and utils.inside(x, y, slot.x, slot.y, config.slot, config.slot) then return slot.class end
    end
end

function Toolbar:update(dt, selected)
    if selected and selected ~= self.selected then self:_remember(selected) end
    self.selected = selected

    local target = self.open and 1 or 0
    local reveal = utils.lerp(self.reveal, target, math.min(1, config.pop.speed * dt))
    self.reveal = math.abs(reveal - target) < 0.005 and target or reveal

    local view = self:_view()
    local hovered = self:_hovered()
    local ease = math.min(1, constants.ui.hover.speed * dt)
    local slide = math.min(1, config.slide * dt)

    for _, slot in ipairs(view.slots) do
        local x = utils.lerp(self.xs[slot.class] or slot.x, slot.x, slide)
        self.xs[slot.class] = math.abs(x - slot.x) < 0.5 and slot.x or x
        self.hover[slot.class] = utils.lerp(self.hover[slot.class] or 0, slot.class == hovered and 1 or 0, ease)
    end

    local drag = self.drag
    if drag and drag.active then
        Lift.follow(drag.card, love.mouse.getX() - config.slot / 2, love.mouse.getY() - config.slot / 2, dt)
    end
    if self.settle and not Lift.land(self.settle.landing, dt) then self.settle = nil end

    self:_place()
    self:_track()
    self:_flip(dt)
    self.prev.enabled = self.page > 1
    self.next.enabled = self.page < view.pages

    for _, widget in ipairs({ self.picker, self.library, self.prev, self.next }) do
        widget:update(dt)
    end
end

function Toolbar:mousepressed(x, y, button)
    local recent = self:_recentAt(x, y)
    if recent and button == 1 then
        self.open = false
        self.on.pick(recent)
        return true
    end

    if not self:contains(x, y) then
        self.open = false
        return false
    end

    local class = self:slotAt(x, y)
    if button == 2 and class then self:remove(class) end
    if button ~= 1 then return true end

    if class then
        Audio.play("click")
        self.drag = {
            class = class,
            x = x,
            y = y,
            active = false,
            index = utils.indexOf(self.items, class),
            card = Lift.new(self.xs[class], self:_rowY())
        }
    elseif self.library:hit(x, y) then
        self.on.library()
    elseif self.picker:hit(x, y) then
        self.on.menu()
    elseif self.prev:hit(x, y) then
        self.page = self.page - 1
    elseif self.next:hit(x, y) then
        self.page = self.page + 1
    elseif self:_overInfo(x, y) and #self.history > 0 then
        Audio.play("click")
        self.open = not self.open
    end
    return true
end

function Toolbar:mousemoved(x, y)
    local drag = self.drag
    if drag and not drag.active and (x - drag.x) ^ 2 + (y - drag.y) ^ 2 > config.drag.threshold ^ 2 then
        drag.active = true
    end
end

function Toolbar:mousereleased(x, y, button)
    local drag = self.drag
    if not drag or button ~= 1 then return end

    if drag.active then
        self.items = self:_order()
        self.settle = { class = drag.class, landing = Lift.release(drag.card) }
        self:_store()
    else
        self.fresh:clear(drag.class)
        self.on.cell(drag.class)
    end
    self.drag = nil
end

function Toolbar:draw(rotation)
    local w, h = love.graphics.getDimensions()
    local view = self:_view()

    love.graphics.setColor(utils.fromHex(config.colors.fill))
    love.graphics.rectangle("fill", 0, h - config.height, w, config.height)
    love.graphics.setColor(utils.fromHex(config.colors.line))
    love.graphics.rectangle("fill", 0, h - config.height, w, 2)
    love.graphics.rectangle("fill", config.start - config.gap, h - config.height + config.margin, 2, config.slot)
    love.graphics.rectangle("fill", w - self:_reserve(), h - config.height + config.margin, 2, config.slot)

    if #self.items == 0 then
        local font, previousFont = self.renderer:font(config.empty.font), love.graphics.getFont()

        love.graphics.setFont(font)
        love.graphics.setColor(utils.fromHex(colors.white, config.empty.alpha))
        love.graphics.print(config.empty.text, config.start + config.empty.margin, h - config.height / 2 - font:getHeight() / 2)
        love.graphics.setFont(previousFont)
    end

    self.picker:draw()
    self.library:draw()
    if view.arrows then
        self.prev:draw()
        self.next:draw()
    end
    self:_drawInfo(rotation)

    love.graphics.setScissor(config.start - config.pad / 2, 0, view.width, h)
    local drag = self.drag and self.drag.active and self.drag
    local held = drag or self.settle
    for _, slot in ipairs(view.slots) do
        local x = self.xs[slot.class] or slot.x
        if x < config.start + view.width and x + config.slot > config.start then
            if not (held and slot.class == held.class) then
                self:_drawSlot(slot, rotation)
            elseif drag then
                Panel.placeholder(x + config.inset, slot.y + config.inset, config.slot - config.inset * 2, config.slot - config.inset * 2, 1)
            end
        end
    end
    love.graphics.setScissor()

    if drag then self:_drawCard(drag.class, drag.card, rotation) end
    if self.settle then
        for _, slot in ipairs(view.slots) do
            if slot.class == self.settle.class then
                self:_drawCard(slot.class, Lift.at(self.settle.landing, slot.x, slot.y), rotation)
            end
        end
    end
    self:_drawRecent(rotation)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Toolbar:drawTooltip()
    local hovered = self:_hovered()
    local recent = not Widget.blocked and self:_recentAt(love.mouse.getPosition())

    self.picker:drawTooltip(self.tooltip)
    self.library:drawTooltip(self.tooltip)
    if hovered then self.tooltip:draw(hovered.title, hovered.description) end
    if recent then self.tooltip:draw(recent.title, recent.description) end
    if self:_infoHovered() then self.tooltip:draw(self.selected.title, self.selected.description) end
end

return Toolbar
