local ScrollList = require("src/ui/widgets/ScrollList")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.dropdown
local colors = constants.ui.colors

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(data)
    local self = setmetatable({}, Dropdown)
    self.renderer = data.renderer
    self.onPick = data.onPick
    self.items = data.items
    self.shown, self.t = false, 0
    self.x, self.y, self.width = 0, 0, config.width
    self.list = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.height,
        drawRow = function(...) self:_drawRow(...) end
    })
    self.list:setItems(self.items)
    return self
end

function Dropdown.owner(widgets)
    for _, widget in ipairs(widgets) do
        if widget.menu and widget.menu.shown then return widget end
    end
end

function Dropdown:_drawRow(item, x, y, _, height, _, selected)
    local font = self.renderer:font(config.font)

    local left = x + config.inset
    local alpha = (selected and 1 or 0.7) * self.list.fade

    if item.icon then
        local texture = self.renderer.textures.cells[item.icon]
        love.graphics.setColor(utils.fromHex(colors.white, alpha))
        love.graphics.draw(texture, left, y + (height - config.icon) / 2, 0, config.icon / texture:getWidth(), config.icon / texture:getHeight())
        left = left + config.icon + config.gap
    end

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.print(item.title, left, y + (height - font:getHeight()) / 2)
end

function Dropdown:_sync()
    self.list:place(self.x, self.y - (1 - self.t) * config.slide, self.width, self:height())
end

function Dropdown:height()
    return #self.items * config.height + constants.ui.list.pad * 2
end

function Dropdown:select(id)
    for index, item in ipairs(self.items) do
        if item.id == id then self.list:select(index) end
    end
end

function Dropdown:place(x, y, width)
    self.x, self.y, self.width = x, y, width or config.width
    self:_sync()
end

function Dropdown:show()
    self.shown = true
end

function Dropdown:hide()
    self.shown, self.t = false, 0
end

function Dropdown:contains(x, y)
    return self.shown and utils.inside(x, y, self.list.x, self.list.y, self.list.width, self.list.height)
end

function Dropdown:update(dt)
    local goal = self.shown and 1 or 0
    self.t = utils.lerp(self.t, goal, math.min(1, config.speed * dt))
    if math.abs(self.t - goal) < 0.01 then self.t = goal end

    self.list.fade = self.t
    self:_sync()
    self.list:update(dt, self.shown)
end

function Dropdown:mousepressed(x, y)
    if not self.shown then return false end

    local index = self.list:rowAt(x, y)
    self.shown = false
    if index then
        Audio.play("click")
        self.list:select(index)
        self.onPick(self.items[index])
    end
    return true
end

function Dropdown:draw()
    if self.t > 0 then self.list:draw() end
end

return Dropdown
