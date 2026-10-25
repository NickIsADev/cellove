local Button = require("src/ui/widgets/Button")
local IconButton = require("src/ui/widgets/IconButton")
local Label = require("src/ui/widgets/Label")
local Separator = require("src/ui/widgets/Separator")
local Swatch = require("src/ui/widgets/Swatch")
local Stepper = require("src/ui/widgets/Stepper")
local TextField = require("src/ui/widgets/TextField")
local Toggle = require("src/ui/widgets/Toggle")
local Tooltip = require("src/ui/overlays/Tooltip")
local constants = require("src/constants")
local utils = require("src/utils")

local toolbar = constants.toolbar
local config = toolbar.panel
local size = toolbar.slot

local factories = {
    icon = function(renderer, spec)
        return IconButton.new({
            renderer = renderer,
            id = spec.id,
            folder = spec.folder,
            texture = spec.texture,
            rotation = spec.rotation,
            size = size,
            title = spec.title,
            description = spec.description
        })
    end,
    text = function(renderer, spec)
        return Button.new({
            renderer = renderer,
            id = spec.id,
            label = spec.label,
            width = spec.width
        })
    end,
    label = function(renderer, spec)
        return Label.new({
            renderer = renderer,
            id = spec.id,
            width = spec.width or size,
            height = size
        })
    end,
    separator = function(renderer, spec)
        return Separator.new({
            renderer = renderer,
            id = spec.id,
            height = size
        })
    end,
    stepper = function(renderer, spec)
        return Stepper.new({
            renderer = renderer,
            key = spec.key,
            label = spec.label,
            min = spec.min,
            max = spec.max,
            value = spec.value,
            width = spec.width
        })
    end,
    toggle = function(renderer, spec)
        return Toggle.new({
            renderer = renderer,
            key = spec.key,
            label = spec.label,
            value = spec.value,
            width = spec.width
        })
    end,
    field = function(renderer, spec)
        return TextField.new({
            renderer = renderer,
            key = spec.key,
            label = spec.label,
            limit = spec.limit,
            value = spec.value,
            width = spec.width,
            focused = false
        })
    end,
    swatch = function(renderer, spec)
        return Swatch.new({
            renderer = renderer,
            id = spec.id,
            title = spec.title,
            description = spec.description,
            height = size
        })
    end
}

local function pressed(widget, x, y, button)
    if widget.mousepressed then return widget:mousepressed(x, y, button) end
    return widget:hit(x, y)
end

local ToolPanel = {}
ToolPanel.__index = ToolPanel

function ToolPanel.build(renderer, specs)
    local widgets, byId = {}, {}
    for _, spec in ipairs(specs) do
        local widget = factories[spec.kind](renderer, spec)
        widget.gap = spec.gap or config.pad
        widgets[#widgets + 1] = widget
        if spec.id then byId[spec.id] = widget end
    end
    return widgets, byId
end

function ToolPanel.new(renderer)
    local self = setmetatable({}, ToolPanel)
    self.tooltip = Tooltip.new(renderer)
    self.box = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }
    return self
end

function ToolPanel:_layout()
    local box, rows = self.box, { {} }
    local limit = love.graphics.getWidth() - toolbar.start - config.pad
    local width, x = 0, 0

    for _, widget in ipairs(self.tool.widgets) do
        if x > 0 and x + widget.width > limit then
            rows[#rows + 1] = {}
            x = 0
        end
        table.insert(rows[#rows], widget)
        x = x + widget.width + widget.gap
        width = math.max(width, x - widget.gap)
    end

    box.width, box.height = width + config.pad * 2, #rows * (size + config.pad) + config.pad
    box.x, box.y = toolbar.start - config.pad, love.graphics.getHeight() - toolbar.height - box.height - config.gap

    for index, row in ipairs(rows) do
        x = toolbar.start
        for _, widget in ipairs(row) do
            widget:place(x, box.y + config.pad + (index - 1) * (size + config.pad))
            x = x + widget.width + widget.gap
        end
    end
end

function ToolPanel:set(tool)
    self.tool = tool
    self:_layout()
end

function ToolPanel:contains(x, y)
    local box = self.box
    return utils.inside(x, y, box.x, box.y, box.width, box.height)
end

function ToolPanel:update(dt)
    self.tool:refresh()
    self:_layout()
    for _, widget in ipairs(self.tool.widgets) do
        widget:update(dt)
    end
end

function ToolPanel:mousepressed(x, y, button)
    if not self:contains(x, y) then return false end

    if button == 1 then
        for _, widget in ipairs(self.tool.widgets) do
            if pressed(widget, x, y, button) then
                self.tool:click(widget.id)
                break
            end
        end
    end
    return true
end

function ToolPanel:mousemoved(x, y)
    for _, widget in ipairs(self.tool.widgets) do
        if widget.mousemoved then widget:mousemoved(x, y) end
    end
end

function ToolPanel:mousereleased(x, y, button)
    for _, widget in ipairs(self.tool.widgets) do
        if widget.mousereleased then widget:mousereleased(x, y, button) end
    end
end

function ToolPanel:draw()
    for _, widget in ipairs(self.tool.widgets) do
        widget:draw()
    end
end

function ToolPanel:drawTooltip()
    for _, widget in ipairs(self.tool.widgets) do
        if widget.drawTooltip then widget:drawTooltip(self.tooltip) end
    end
end

return ToolPanel
