local IconButton = require("src/ui/widgets/IconButton")
local Stepper = require("src/ui/widgets/Stepper")
local TextField = require("src/ui/widgets/TextField")
local Toggle = require("src/ui/widgets/Toggle")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.prompt
local colors = constants.ui.colors

local kinds = {
    stepper = Stepper,
    toggle = Toggle,
    field = TextField
}

local function makeButton(renderer, texture, tint, label)
    return IconButton.new({
        renderer = renderer,
        folder = "ui",
        texture = texture,
        size = config.button.size,
        tint = tint,
        label = label,
        labelFont = config.button.font,
        labelGap = config.button.labelGap
    })
end

local Prompt = {}
Prompt.__index = Prompt

function Prompt.new(renderer)
    local self = setmetatable({}, Prompt)
    self.renderer = renderer
    self.active = false
    self.box = {}
    self.inputs = {}
    self.message = ""

    self.confirmButton = makeButton(renderer, "checkmark", colors.accent, config.text.confirm)
    self.cancelButton = makeButton(renderer, "x", colors.danger, config.text.cancel)
    return self
end

function Prompt:_layout()
    local w, h = love.graphics.getDimensions()
    local titleFont = self.renderer:font(config.font.title)
    local textFont = self.renderer:font(config.font.text)
    local labelFont = self.renderer:font(config.button.font)
    local box = self.box
    local button = config.button

    local label = 0
    for _, input in ipairs(self.inputs) do
        label = math.max(label, input.labelWidth, textFont:getWidth(input.label) + config.gap)
    end

    local content = math.max(label + config.control, Panel.headingWidth(titleFont, self.title, self.icon))
    box.width = math.min(math.max(config.width, content + config.pad * 2), w - config.margin * 2)
    box.inner = box.width - config.pad * 2

    local messageHeight = 0
    if self.message ~= "" then
        local _, lines = textFont:getWrap(self.message, box.inner)
        messageHeight = #lines * textFont:getHeight() + config.gap
    end

    local fieldHeight = self.field and constants.ui.field.height + config.gap or 0
    local inputsHeight = 0
    for _, input in ipairs(self.inputs) do
        inputsHeight = inputsHeight + input.height + config.gap
    end
    local buttonsHeight = button.size + button.labelGap + labelFont:getHeight()

    box.height = config.pad * 2 + titleFont:getHeight() + config.gap + messageHeight + fieldHeight + inputsHeight + buttonsHeight
    box.x, box.y = (w - box.width) / 2, (h - box.height) / 2
    box.messageY = box.y + config.pad + titleFont:getHeight() + config.gap
    box.fieldY = box.messageY + messageHeight
    box.inputsY = box.fieldY + fieldHeight
    box.buttonY = box.y + box.height - config.pad - buttonsHeight

    if self.field then self.field:place(box.x + config.pad, box.fieldY, box.inner) end

    local y = box.inputsY
    for _, input in ipairs(self.inputs) do
        input.labelWidth = label
        input:place(box.x + config.pad, y, box.inner)
        y = y + input.height + config.gap
    end

    local left = box.x + (box.width - (button.size * 2 + button.gap)) / 2
    self.cancelButton:place(left, box.buttonY, button.size)
    self.confirmButton:place(left + button.size + button.gap, box.buttonY, button.size)
end

function Prompt:_valid()
    return not self.field or utils.trim(self.field.text) ~= ""
end

function Prompt:_focus()
    for _, input in ipairs(self.inputs) do
        if input.focused then return input end
    end
    return self.field
end

function Prompt:_cancel()
    self:close()
    if self.onCancel then self.onCancel() end
end

function Prompt:_confirm()
    if not self:_valid() then return end

    local text = self.field and utils.trim(self.field.text)
    local values = {}
    for _, input in ipairs(self.inputs) do
        values[input.key] = input:get()
    end

    self:close()
    self.onConfirm(text, values)
end

function Prompt:open(options)
    self.active = true
    self.title = options.title
    self.icon = options.icon
    self.message = options.message or ""
    self.field = options.text and TextField.new({
        renderer = self.renderer,
        limit = options.limit,
        filter = options.filter
    })
    if self.field then self.field:set(options.text) end
    self.onConfirm = options.onConfirm
    self.onCancel = options.onCancel
    self.confirmButton.label = options.confirm or config.text.confirm

    self.inputs = {}
    for _, field in ipairs(options.fields or {}) do
        self.inputs[#self.inputs + 1] = kinds[field.kind or "stepper"].new({
            renderer = self.renderer,
            key = field.key,
            label = field.label,
            min = field.min,
            max = field.max,
            limit = field.limit,
            value = field.value,
            focused = false
        })
    end

    self.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
end

function Prompt:close()
    self.active = false
    love.keyboard.setKeyRepeat(self.keyRepeat)
end

function Prompt:update(dt)
    if not self.active then return end

    self:_layout()
    if self.field then self.field:update(dt) end
    self.confirmButton.enabled = self:_valid()
    self.confirmButton:update(dt)
    self.cancelButton:update(dt)
    for _, input in ipairs(self.inputs) do input:update(dt) end
end

function Prompt:mousepressed(x, y, button)
    if not self.active then return false end

    self:_layout()
    if button ~= 1 then return true end

    local hit = false
    for _, input in ipairs(self.inputs) do
        hit = input:mousepressed(x, y, button) or hit
    end
    if hit then return true end

    if self.confirmButton:hit(x, y) then
        self:_confirm()
    elseif self.cancelButton:hit(x, y) then
        self:_cancel()
    end
    return true
end

function Prompt:mousemoved(x, y)
    for _, input in ipairs(self.inputs) do
        if input.mousemoved then input:mousemoved(x, y) end
    end
end

function Prompt:mousereleased(x, y, button)
    for _, input in ipairs(self.inputs) do
        if input.mousereleased then input:mousereleased(x, y, button) end
    end
end

function Prompt:keypressed(key)
    if not self.active then return false end

    local focus = self:_focus()
    if key == "escape" then
        self:_cancel()
    elseif key == "return" or key == "kpenter" then
        self:_confirm()
    elseif focus then
        focus:keypressed(key)
    end
    return true
end

function Prompt:textinput(text)
    local focus = self:_focus()
    if self.active and focus then focus:textinput(text) end
end

function Prompt:draw()
    if not self.active then return end

    self:_layout()
    local box = self.box
    local renderer = self.renderer
    local previousFont = love.graphics.getFont()
    local w, h = love.graphics.getDimensions()

    love.graphics.setColor(utils.fromHex(0x000000, config.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)

    Panel.draw(box.x, box.y, box.width, box.height, { alpha = 1 })

    Panel.heading(renderer, renderer:font(config.font.title), box.x + config.pad, box.y + config.pad, self.title, self.icon)

    if self.message ~= "" then
        love.graphics.setFont(renderer:font(config.font.text))
        love.graphics.setColor(utils.fromHex(colors.white, 0.8))
        love.graphics.printf(self.message, box.x + config.pad, box.messageY, box.inner)
    end

    if self.field then self.field:draw() end
    for _, input in ipairs(self.inputs) do input:draw() end
    self.cancelButton:draw()
    self.confirmButton:draw()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Prompt
