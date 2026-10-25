local ToolPanel = require("src/editor/panels/ToolPanel")
local Properties = require("src/engine/data/Properties")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.properties
local toolbar = constants.toolbar
local separator = constants.ui.separator
local colors = constants.ui.colors

local PropertyPanel = {}
PropertyPanel.__index = PropertyPanel

function PropertyPanel.new(renderer)
    local self = setmetatable({}, PropertyPanel)
    self.renderer = renderer
    self.focus = false
    self.box = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }
    self:reset()
    return self
end

function PropertyPanel:_inputs(class)
    if not class then return {} end

    if not self.inputs[class] then
        self.inputs[class] = ToolPanel.build(self.renderer, Properties.specs(class.properties))
    end
    return self.inputs[class]
end

function PropertyPanel:_focused()
    for _, widget in ipairs(self.widgets) do
        if widget.focused then return widget end
    end
end

function PropertyPanel:_layout()
    if #self.widgets == 0 then return end

    local box = self.box
    local titleFont, labelFont = self.renderer:font(config.font), self.renderer:font(config.label.font)
    local title = config.pad + titleFont:getHeight()
    local start = title + config.gap * 2 + separator.width
    local height = start + config.gap * (#self.widgets - 1) + config.pad
    local label = 0

    for _, widget in ipairs(self.widgets) do
        height = height + widget.height
        label = math.max(label, labelFont:getWidth(widget.label) + config.label.gap)
    end

    box.width = math.max(label + config.control, Panel.headingWidth(titleFont, self.class.title, self.class.texture)) + config.pad * 2
    box.height = height
    box.x = love.graphics.getWidth() - config.margin - box.width
    box.y = love.graphics.getHeight() - toolbar.height - config.margin - height

    local y = box.y + start
    for _, widget in ipairs(self.widgets) do
        widget.labelWidth = label
        widget:place(box.x + config.pad, y, box.width - config.pad * 2)
        y = y + widget.height + config.gap
    end
end

function PropertyPanel:values(class)
    local props = {}
    for _, input in ipairs(self:_inputs(class)) do
        props[input.key] = input:get()
    end
    return props
end

function PropertyPanel:load(class, props)
    for _, input in ipairs(self:_inputs(class)) do
        input:set(props[input.key])
    end
end

function PropertyPanel:contains(x, y)
    local box = self.box
    return #self.widgets > 0 and utils.inside(x, y, box.x, box.y, box.width, box.height)
end

function PropertyPanel:typing()
    return self:_focused() ~= nil
end

function PropertyPanel:reset()
    self.inputs, self.widgets, self.class = {}, {}, nil
end

function PropertyPanel:update(dt, class)
    self.class, self.widgets = class, self:_inputs(class)
    self:_layout()

    for _, widget in ipairs(self.widgets) do
        widget:update(dt)
    end

    if self:typing() ~= self.focus then
        self.focus = self:typing()
        love.keyboard.setKeyRepeat(self.focus)
    end
end

function PropertyPanel:mousepressed(x, y, button)
    for _, widget in ipairs(self.widgets) do
        widget:mousepressed(x, y, button)
    end
    return self:contains(x, y)
end

function PropertyPanel:mousemoved(x, y)
    for _, widget in ipairs(self.widgets) do
        if widget.mousemoved then widget:mousemoved(x, y) end
    end
end

function PropertyPanel:mousereleased(x, y, button)
    for _, widget in ipairs(self.widgets) do
        if widget.mousereleased then widget:mousereleased(x, y, button) end
    end
end

function PropertyPanel:keypressed(key)
    local field = self:_focused()
    if not field then return false end

    if key == "escape" or key == "return" or key == "kpenter" then
        field.focused = false
    else
        field:keypressed(key)
    end
    return true
end

function PropertyPanel:textinput(text)
    local field = self:_focused()
    if field then field:textinput(text) end
end

function PropertyPanel:draw()
    if #self.widgets == 0 then return end

    local box = self.box
    local previousFont = love.graphics.getFont()

    Panel.draw(box.x, box.y, box.width, box.height)

    Panel.heading(self.renderer, self.renderer:font(config.font), box.x + config.pad, box.y + config.pad, self.class.title, self.class.texture)

    local line = self.widgets[1].y - config.gap - separator.width
    Panel.fill(box.x + config.pad, line, box.width - config.pad * 2, separator.width, colors.white, separator.alpha)

    for _, widget in ipairs(self.widgets) do
        widget:draw()
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return PropertyPanel
