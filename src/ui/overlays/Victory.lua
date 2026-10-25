local IconButton = require("src/ui/widgets/IconButton")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.victory
local colors = constants.ui.colors
local shadow = constants.ui.shadow

local Victory = {}
Victory.__index = Victory

function Victory.new(renderer)
    local self = setmetatable({}, Victory)
    self.renderer = renderer
    self.active = false
    self.age = 0
    self.box = {}
    self.shown = {}
    self.buttons = {}

    for index, spec in ipairs(config.buttons) do
        self.buttons[index] = IconButton.new({
            renderer = renderer,
            id = spec.id,
            folder = spec.folder,
            texture = spec.texture,
            size = config.button.size,
            tint = colors[spec.tint or "white"],
            label = spec.label,
            labelFont = config.button.font,
            labelGap = config.button.labelGap
        })
    end
    return self
end

function Victory:_ready()
    return self.age >= config.fade
end

function Victory:_layout()
    local w, h = love.graphics.getDimensions()
    local renderer, button, font = self.renderer, config.button, config.font
    local title, name, label = renderer:font(font.title), renderer:font(font.name), renderer:font(button.font)
    local box = self.box

    box.width = math.min(config.width, w - config.margin * 2)
    box.inner = box.width - config.pad * 2

    local buttonsHeight = button.size + button.labelGap + label:getHeight()

    box.height = config.pad * 2 + config.gap + title:getHeight() + name:getHeight() + config.pad + buttonsHeight
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2
    box.nameY = box.y + config.pad + title:getHeight() + config.gap
    box.buttonY = box.y + box.height - config.pad - buttonsHeight

    local width = #self.shown * button.size + (#self.shown - 1) * button.gap
    local left = box.x + (box.width - width) / 2
    for index, item in ipairs(self.shown) do
        item:place(left + (index - 1) * (button.size + button.gap), box.buttonY, button.size)
    end
end

function Victory:open(options)
    self.active = true
    self.age = 0
    self.actions = options.actions
    self.name = options.name
    self.shown = {}

    for _, item in ipairs(self.buttons) do
        if self.actions[item.id] then self.shown[#self.shown + 1] = item end
    end
end

function Victory:close()
    self.active = false
end

function Victory:update(dt)
    if not self.active then return end

    self.age = self.age + dt
    self:_layout()
    for _, item in ipairs(self.shown) do item:update(dt) end
end

function Victory:mousepressed(x, y, button)
    if not self.active then return false end
    if button ~= 1 or not self:_ready() then return true end

    self:_layout()
    for _, item in ipairs(self.shown) do
        if item:hit(x, y) then self.actions[item.id]() end
    end
    return true
end

function Victory:keypressed(key)
    if not self.active then return false end

    if self:_ready() then
        if key == "return" or key == "kpenter" then
            self.actions[self.actions.next and "next" or "puzzles"]()
        elseif key == "escape" then
            self.actions.puzzles()
        end
    end
    return true
end

function Victory:draw()
    if not self.active then return end

    self:_layout()
    local box, renderer = self.box, self.renderer
    local w, h = love.graphics.getDimensions()
    local previousFont = love.graphics.getFont()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim * math.min(1, self.age / config.fade)))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    love.graphics.setFont(renderer:font(config.font.title))
    utils.drawShadowed(function(ox, oy)
        love.graphics.printf(config.title, box.x + config.pad + ox, box.y + config.pad + oy, box.inner, "center")
    end, shadow.offset, shadow.alpha, colors.accent)

    love.graphics.setFont(renderer:font(config.font.name))
    love.graphics.setColor(utils.fromHex(colors.white, 0.7))
    love.graphics.printf(self.name, box.x + config.pad, box.nameY, box.inner, "center")

    for _, item in ipairs(self.shown) do item:draw() end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Victory
