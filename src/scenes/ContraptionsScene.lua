local ScrollingBackground = require("src/ui/decor/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollList = require("src/ui/widgets/ScrollList")
local Title = require("src/ui/decor/Title")
local Panel = require("src/ui/Panel")
local Prompt = require("src/ui/overlays/Prompt")
local Toast = require("src/ui/overlays/Toast")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.selector
local files = constants.contraptions
local text = config.text
local colors = constants.ui.colors

local ContraptionsScene = {}
ContraptionsScene.__index = ContraptionsScene

function ContraptionsScene.new(data)
    local self = setmetatable({}, ContraptionsScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.contraptions = data.contraptions
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, config.title)
    self.prompt = Prompt.new(data.renderer)
    self.toast = Toast.new(data.renderer)
    self.tooltip = Tooltip.new(data.renderer)
    self.list = ScrollList.new({
        renderer = data.renderer,
        rowHeight = config.row.height,
        emptyText = text.empty,
        emptyFont = constants.ui.back.font,
        drawRow = function(...) self:_drawRow(...) end
    })

    self.buttons = {}
    self.byId = {}
    for _, spec in ipairs(config.buttons) do
        local button = IconButton.new({
            renderer = data.renderer,
            id = spec.id,
            folder = spec.folder,
            texture = spec.texture,
            rotation = spec.rotation,
            size = config.bar.size,
            title = spec.title,
            description = spec.description
        })
        button.group = spec.group
        self.buttons[#self.buttons + 1] = button
        self.byId[spec.id] = button
    end

    self.actions = {
        new = self._create,
        import = self._import,
        folder = self._openFolder,
        open = self._play,
        puzzle = self._puzzle,
        rename = self._rename,
        export = self._export,
        delete = self._delete
    }

    self.separators = {}
    self.left, self.barY = 0, 0
    return self
end

function ContraptionsScene:_layout()
    local w, h = love.graphics.getDimensions()
    local bar = config.bar
    local width = math.min(config.width, w - config.margin * 2)
    local left = (w - width) / 2
    local top = math.max(config.top.min, math.min(h * config.top.ratio, h - config.top.room))
    local listTop = top + bar.size + config.gap

    self.left, self.barY = left, top
    self.list:place(left, listTop, width, h - config.margin - listTop)

    local total, previous = 0, nil
    for _, button in ipairs(self.buttons) do
        if previous then
            total = total + bar.gap + (button.group ~= previous.group and bar.group or 0)
        end
        total = total + bar.size
        previous = button
    end

    local x = left + width - total
    previous = nil
    self.separators = {}
    for _, button in ipairs(self.buttons) do
        if previous then
            local extra = button.group ~= previous.group and bar.group or 0
            x = x + bar.gap + extra
            if extra > 0 then self.separators[#self.separators + 1] = x - (bar.gap + extra) / 2 end
        end
        button:place(x, top)
        x = x + bar.size
        previous = button
    end
end

function ContraptionsScene:_refresh(name)
    local current = self.list:current()
    name = name or (current and current.name)

    local entries = self.contraptions:list()
    local selected = #entries > 0 and 1 or nil
    for index, entry in ipairs(entries) do
        if entry.name == name then selected = index end
    end

    self:_layout()
    self.list:setItems(entries, selected)
end

function ContraptionsScene:_ask(dialog, options)
    options.title = dialog.title
    options.message = options.message or dialog.message
    options.confirm = dialog.confirm
    options.filter = files.forbidden
    options.limit = files.maxName
    self.prompt:open(options)
end

function ContraptionsScene:_store(name, data)
    name = self.contraptions:unique(name)
    if not self.contraptions:save(name, data) then return self.toast:show(text.toast.saveFailed, true) end
    return name
end

function ContraptionsScene:_add(name, data)
    name = self:_store(name, data)
    if not name then return end

    self:_refresh(name)
    self.toast:show(string.format(text.toast.imported, name))
end

function ContraptionsScene:_create()
    local size = constants.grid.default
    local limits = constants.grid.limits

    self:_ask(text.new, {
        text = self.contraptions:unique(files.defaultName),
        fields = {
            {
                key = "width",
                label = text.width,
                min = limits.min,
                max = limits.max,
                value = size.width
            },
            {
                key = "height",
                label = text.height,
                min = limits.min,
                max = limits.max,
                value = size.height
            }
        },
        onConfirm = function(name, values)
            name = self:_store(name, self.contraptions:blank(values.width, values.height))
            if name then self.manager:switch("game", { name = name }) end
        end
    })
end

function ContraptionsScene:_import()
    local data, err = self.contraptions:import(love.system.getClipboardText())
    if not data then return self.toast:show(err, true) end

    self:_ask(text.import, {
        text = self.contraptions:unique(files.importName),
        onConfirm = function(name) self:_add(name, data) end
    })
end

function ContraptionsScene:_openFolder()
    self.contraptions:open()
end

function ContraptionsScene:_rename()
    local entry = self.list:current()
    if not entry then return end

    self:_ask(text.rename, {
        text = entry.name,
        onConfirm = function(name)
            name = self.contraptions:clean(name)
            if not name or name == entry.name then return end

            name = self.contraptions:unique(name)
            if not self.contraptions:rename(entry.name, name) then return self.toast:show(text.toast.saveFailed, true) end

            self:_refresh(name)
            self.toast:show(string.format(text.toast.renamed, entry.name, name))
        end
    })
end

function ContraptionsScene:_export()
    local entry = self.list:current()
    if not entry or not entry.valid then return end

    love.system.setClipboardText(self.contraptions:text(entry.name))
    self.toast:show(string.format(text.toast.copied, entry.name))
end

function ContraptionsScene:_delete()
    local entry = self.list:current()
    if not entry then return end

    self:_ask(text.delete, {
        message = string.format(text.delete.message, entry.name),
        onConfirm = function()
            local index = self.list.selected
            self.contraptions:delete(entry.name)

            local neighbor = self.list.items[index + 1] or self.list.items[index - 1]
            self:_refresh(neighbor and neighbor.name)
            self.toast:show(string.format(text.toast.deleted, entry.name))
        end
    })
end

function ContraptionsScene:_play()
    local entry = self.list:current()
    if not (entry and entry.valid) then return end

    local open = function() self.manager:switch("game", { name = entry.name }) end
    if not (entry.missing and #entry.missing > 0) then return open() end

    self:_ask(text.missing, {
        message = string.format(text.missing.message, table.concat(entry.missing, ", ")),
        onConfirm = open
    })
end

function ContraptionsScene:_puzzle()
    local entry = self.list:current()
    if entry and entry.valid then
        self.manager:switch("puzzle", {
            name = entry.name,
            data = self.contraptions:load(entry.name),
            back = { scene = "contraptions", data = { select = entry.name } }
        })
    end
end

function ContraptionsScene:_drawRow(entry, x, y, width, height, hover, selected)
    local renderer = self.renderer
    local row = config.row
    local nameFont = renderer:font(row.font.name)
    local detailFont = renderer:font(row.font.detail)
    local missing = entry.missing and #entry.missing > 0
    local kind = not entry.valid and "invalid" or missing and "missing" or "valid"
    local icon = renderer.textures.cells[config.icons[kind]]
    local scale = row.icon / icon:getWidth()
    local iconX = x + row.pad

    love.graphics.setColor(utils.fromHex(colors.white, kind == "valid" and 1 or 0.5))
    love.graphics.draw(icon, iconX, y + (height - row.icon) / 2, 0, scale, scale)

    local textX = iconX + row.icon + row.pad
    local textWidth = x + width - row.pad - textX
    local blockHeight = nameFont:getHeight() + row.lineGap + detailFont:getHeight()
    local nameY = y + (height - blockHeight) / 2
    local metaY = nameY + nameFont:getHeight() + row.lineGap

    love.graphics.setFont(nameFont)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * (selected and 1 or hover)))
    utils.printFitted(entry.name, textX, nameY, textWidth)

    love.graphics.setFont(detailFont)
    if entry.valid then
        local date = os.date(text.date, entry.modtime)
        local dateWidth = detailFont:getWidth(date)

        love.graphics.setColor(utils.fromHex(colors.white, 0.5))
        utils.printFitted(string.format(text.detail, entry.width, entry.height, entry.count),
            textX, metaY, textWidth - dateWidth - row.pad)

        love.graphics.setColor(utils.fromHex(colors.white, 0.35))
        love.graphics.print(date, x + width - row.pad - dateWidth, metaY)
    else
        love.graphics.setColor(utils.fromHex(colors.danger, 0.8))
        utils.printFitted(text.invalid, textX, metaY, textWidth)
    end
end

function ContraptionsScene:_drawBar()
    local bar = config.bar
    local font = self.renderer:font(bar.font)
    local count = #self.list.items

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.5))
    love.graphics.print(string.format(count == 1 and text.count.one or text.count.other, count),
        self.left, self.barY + (bar.size - font:getHeight()) / 2)

    for _, x in ipairs(self.separators) do
        Panel.fill(x - 1, self.barY + bar.inset, 2, bar.size - bar.inset * 2, colors.white, 0.2)
    end
    for _, button in ipairs(self.buttons) do button:draw() end
end

function ContraptionsScene:enter(_, data)
    self.toast:clear()
    self.list:resetScroll()
    self:_refresh(data and data.select)
end

function ContraptionsScene:leave()
    self.toast:clear()
    if self.prompt.active then self.prompt:close() end
end

function ContraptionsScene:update(dt)
    self:_layout()
    self.background:update(dt)
    self.back:update(dt)
    self.toast:update(dt)
    self.prompt:update(dt)
    self.list:update(dt, not self.prompt.active)

    local entry = self.list:current()
    local valid = entry and entry.valid
    self.byId.open.enabled = valid
    self.byId.puzzle.enabled = valid
    self.byId.export.enabled = valid
    self.byId.rename.enabled = entry ~= nil
    self.byId.delete.enabled = entry ~= nil

    for _, button in ipairs(self.buttons) do button:update(dt) end
end

function ContraptionsScene:mousepressed(x, y, button, _, presses)
    if self.prompt:mousepressed(x, y, button) then return end
    if button ~= 1 then return end

    self:_layout()
    if self.back:hit(x, y) then return self.manager:switch("menu") end

    for _, icon in ipairs(self.buttons) do
        if icon:hit(x, y) then return self.actions[icon.id](self) end
    end
    if self.list:mousepressed(x, y, button) then return end

    local index = self.list:rowAt(x, y)
    if index then
        Audio.play("click")
        self.list:select(index)
        if (presses or 1) >= 2 then self:_play() end
    end
end

function ContraptionsScene:mousemoved(x, y)
    self.prompt:mousemoved(x, y)
    self.list:mousemoved(x, y)
end

function ContraptionsScene:mousereleased(x, y, button)
    self.prompt:mousereleased(x, y, button)
    self.list:mousereleased()
end

function ContraptionsScene:wheelmoved(_, y)
    if self.prompt.active then return end
    self.list:wheelmoved(y)
end

function ContraptionsScene:keypressed(key)
    if self.prompt:keypressed(key) then return end

    if key == "escape" then
        self.manager:switch("menu")
    elseif key == "up" then
        self.list:move(-1)
    elseif key == "down" then
        self.list:move(1)
    elseif key == "return" or key == "kpenter" then
        self:_play()
    elseif key == "f2" then
        self:_rename()
    elseif key == "delete" then
        self:_delete()
    end
end

function ContraptionsScene:textinput(input)
    self.prompt:textinput(input)
end

function ContraptionsScene:filedropped(file)
    local name, data, err = self.contraptions:fromFile(file)
    if not data then return self.toast:show(err, true) end

    self:_add(name, data)
end

function ContraptionsScene:focus(focused)
    if focused then self:_refresh() end
end

function ContraptionsScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    self:_drawBar()
    self.list:draw()
    self.back:draw()
    self.toast:draw(love.graphics.getHeight() - config.margin * 2)
    self.prompt:draw()

    if not self.prompt.active then
        for _, button in ipairs(self.buttons) do button:drawTooltip(self.tooltip) end
    end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return ContraptionsScene
