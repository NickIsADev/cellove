local ScrollingBackground = require("src/ui/decor/ScrollingBackground")
local BackButton = require("src/ui/widgets/BackButton")
local IconButton = require("src/ui/widgets/IconButton")
local ScrollView = require("src/ui/widgets/ScrollView")
local Title = require("src/ui/decor/Title")
local Panel = require("src/ui/Panel")
local Prompt = require("src/ui/overlays/Prompt")
local Toast = require("src/ui/overlays/Toast")
local Tooltip = require("src/ui/overlays/Tooltip")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.screenshots
local cell = config.cell
local view = config.preview
local text = config.text
local files = constants.contraptions
local separator = constants.ui.separator
local scroll = constants.ui.list.scroll
local colors = constants.ui.colors

local ScreenshotsScene = {}
ScreenshotsScene.__index = ScreenshotsScene

function ScreenshotsScene.new(data)
    local self = setmetatable({}, ScreenshotsScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.screenshots = data.screenshots
    self.background = ScrollingBackground.new(data.renderer)
    self.back = BackButton.new(data.renderer)
    self.title = Title.new(data.renderer, config.title)
    self.tooltip = Tooltip.new(data.renderer)
    self.prompt = Prompt.new(data.renderer)
    self.toast = Toast.new(data.renderer)
    self.folder = IconButton.new({
        renderer = data.renderer,
        texture = "folder",
        size = config.folder.size,
        title = config.folder.title,
        description = config.folder.description
    })
    self.list = ScrollView.new({
        renderer = data.renderer,
        gap = config.gap,
        drawRow = function(...) self:_drawRow(...) end
    })
    self.actions = {
        rename = self._rename,
        delete = self._delete,
        close = self._close
    }
    self.buttons = {}
    for _, spec in ipairs(view.buttons) do
        self.buttons[#self.buttons + 1] = IconButton.new({
            renderer = data.renderer,
            id = spec.id,
            folder = spec.folder,
            texture = spec.texture,
            size = view.button,
            title = spec.title,
            description = spec.description
        })
    end
    self.shots = {}
    self.images = {}
    self.columns = 0
    return self
end

function ScreenshotsScene:_rows()
    local rows = {}

    for index, shot in ipairs(self.shots) do
        local row = math.ceil(index / self.columns)

        rows[row] = rows[row] or { height = cell.height }
        table.insert(rows[row], shot)
    end
    return rows
end

function ScreenshotsScene:_layout()
    local w, h = love.graphics.getDimensions()
    local width = math.min(config.width, w - config.margin * 2)
    local top = h * config.top.ratio
    local available = width - scroll.width - scroll.gap
    local columns = math.max(1, math.floor((available + config.gap) / (cell.width + config.gap)))

    self.list:place((w - width) / 2, top, width, h - config.bottom - top)
    self.folder:place(w - config.folder.margin - config.folder.size, config.folder.margin)
    self.cellWidth = (available - config.gap * (columns - 1)) / columns

    if columns == self.columns then return end

    self.columns = columns
    self.list:setItems(self:_rows())
end

function ScreenshotsScene:_at(x, y)
    local row = self.list:rowAt(x, y)
    if not row then return end

    local offset = x - self.list:bounds(row)
    local step = self.cellWidth + config.gap
    local column = math.floor(offset / step) + 1

    if column <= self.columns and offset % step <= self.cellWidth then
        return self.list.items[row][column]
    end
end

function ScreenshotsScene:_image(shot)
    if not self.images[shot] then
        local ok, image = pcall(love.graphics.newImage, shot.path, { mipmaps = true })

        if ok then
            image:setFilter("linear", "nearest")
            image:setMipmapFilter("linear")
        end
        self.images[shot] = ok and image or self.renderer.textures.ui.missing
    end
    return self.images[shot]
end

function ScreenshotsScene:_frame()
    local image = self:_image(self.preview)
    local w, h = love.graphics.getDimensions()
    local scale = math.min(
        (w - view.margin * 2 - view.pad * 2) / image:getWidth(),
        (h - view.margin * 2 - view.header - view.pad * 2) / image:getHeight()
    )
    if scale > 1 then scale = math.floor(scale) end

    local width, height = image:getWidth() * scale, image:getHeight() * scale
    local frame = {
        width = math.max(width + view.pad * 2, view.min),
        height = view.header + height + view.pad * 2,
        scale = scale
    }

    frame.x, frame.y = math.floor((w - frame.width) / 2), math.floor((h - frame.height) / 2)
    frame.picture = {
        x = math.floor(frame.x + (frame.width - width) / 2),
        y = frame.y + view.header + view.pad,
        width = width,
        height = height
    }
    return frame
end

function ScreenshotsScene:_place(frame)
    local count = #self.buttons

    for index, button in ipairs(self.buttons) do
        local offset = (count - index) * (view.button + view.gap)

        button:place(frame.x + frame.width - view.pad - view.button - offset, frame.y + (view.header - view.button) / 2)
    end
end

function ScreenshotsScene:_close()
    self.preview = nil
end

function ScreenshotsScene:_rename(shot)
    self.prompt:open({
        title = text.rename.title,
        message = text.rename.message,
        confirm = text.rename.confirm,
        text = shot.name,
        filter = files.forbidden,
        limit = files.maxName,
        onConfirm = function(name)
            name = self.screenshots:clean(name)
            if not name or name == shot.name then return end

            local previous = shot.name
            if not self.screenshots:rename(shot, self.screenshots:unique(name)) then return self.toast:show(text.failed, true) end

            self.toast:show(string.format(text.renamed, previous, shot.name))
        end
    })
end

function ScreenshotsScene:_delete(shot)
    self.prompt:open({
        title = text.delete.title,
        message = string.format(text.delete.message, shot.name),
        confirm = text.delete.confirm,
        onConfirm = function()
            self.screenshots:delete(shot)
            self.images[shot] = nil
            table.remove(self.shots, utils.indexOf(self.shots, shot))
            self.preview, self.columns = nil, 0
            self.toast:show(string.format(text.deleted, shot.name))
        end
    })
end

function ScreenshotsScene:_pressPreview(x, y, button)
    if button ~= 1 then return end

    for _, icon in ipairs(self.buttons) do
        if icon:hit(x, y) then return self.actions[icon.id](self, self.preview) end
    end

    local frame = self:_frame()
    if not utils.inside(x, y, frame.x, frame.y, frame.width, frame.height) then self:_close() end
end

function ScreenshotsScene:_drawShot(shot, x, y)
    local font, image = self.renderer:font(config.font), self:_image(shot)
    local width, height = self.cellWidth - cell.pad * 2, cell.height - cell.pad * 3 - font:getHeight()
    local scale = math.min(width / image:getWidth(), height / image:getHeight())

    Panel.draw(x, y, self.cellWidth, cell.height, { highlight = shot.hover })

    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(image, x + self.cellWidth / 2, y + cell.pad + height / 2, 0, scale, scale, image:getWidth() / 2, image:getHeight() / 2)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.8 + 0.2 * shot.hover))
    utils.printFitted(shot.name, x + cell.pad, y + cell.height - cell.pad - font:getHeight(), width)
end

function ScreenshotsScene:_drawRow(_, row, x, y)
    for column, shot in ipairs(row) do
        self:_drawShot(shot, x + (column - 1) * (self.cellWidth + config.gap), y)
    end
end

function ScreenshotsScene:_drawEmpty()
    local font, list = self.renderer:font(constants.ui.back.font), self.list

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, 0.5))
    love.graphics.printf(config.empty, list.x, list.y + list.height / 2 - font:getHeight() / 2, list.width, "center")
end

function ScreenshotsScene:_drawPreview()
    local frame = self:_frame()
    local picture = frame.picture
    local font, image = self.renderer:font(view.font), self:_image(self.preview)
    local w, h = love.graphics.getDimensions()
    local tray = #self.buttons * (view.button + view.gap)

    love.graphics.setColor(utils.fromHex(0x000000, view.dim))
    love.graphics.rectangle("fill", 0, 0, w, h)
    Panel.draw(frame.x, frame.y, frame.width, frame.height, { alpha = 1 })
    Panel.fill(frame.x + view.pad, frame.y + view.header, frame.width - view.pad * 2, separator.width, colors.white, separator.alpha)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white))
    utils.printFitted(self.preview.name, frame.x + view.pad, frame.y + (view.header - font:getHeight()) / 2, frame.width - view.pad * 2 - tray)

    love.graphics.draw(image, picture.x, picture.y, 0, frame.scale, frame.scale)
    Panel.outline(picture.x, picture.y, picture.width, picture.height, colors.border, 1)

    for _, button in ipairs(self.buttons) do button:draw() end
    for _, button in ipairs(self.buttons) do button:drawTooltip(self.tooltip) end
end

function ScreenshotsScene:enter(_, data)
    self.exit = data and data.back or { scene = "menu" }
    self.shots, self.columns, self.preview = self.screenshots:list(), 0, nil
    for _, shot in ipairs(self.shots) do
        shot.hover = 0
    end
    self.toast:clear()
    self.list:resetScroll()
    self:_layout()
end

function ScreenshotsScene:leave()
    self.images = {}
    if self.prompt.active then self.prompt:close() end
end

function ScreenshotsScene:update(dt)
    self:_layout()
    self.background:update(dt)
    self.back:update(dt)
    self.folder:update(dt)
    self.toast:update(dt)
    self.prompt:update(dt)

    local mx, my = love.mouse.getPosition()
    local hovered = self:_at(mx, my)
    local idle = self.preview or self.prompt.active
    local ease = math.min(1, constants.ui.hover.speed * dt)

    for _, shot in ipairs(self.shots) do
        shot.hover = utils.lerp(shot.hover, shot == hovered and not idle and 1 or 0, ease)
    end

    if not self.preview then return end

    self:_place(self:_frame())
    for _, button in ipairs(self.buttons) do button:update(dt) end
end

function ScreenshotsScene:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) then return end
    if self.preview then return self:_pressPreview(x, y, button) end

    if button ~= 1 then return end

    if self.back:hit(x, y) then return self.manager:switch(self.exit.scene, self.exit.data) end
    if self.folder:hit(x, y) then return self.screenshots:open() end

    local shot = self:_at(x, y)
    if self.list:mousepressed(x, y, button) or not shot then return end

    Audio.play("click")
    self.preview = shot
end

function ScreenshotsScene:mousemoved(x, y)
    self.prompt:mousemoved(x, y)
    self.list:mousemoved(x, y)
end

function ScreenshotsScene:mousereleased(x, y, button)
    self.prompt:mousereleased(x, y, button)
    if button == 1 then self.list:mousereleased() end
end

function ScreenshotsScene:wheelmoved(_, y)
    if not (self.preview or self.prompt.active) then self.list:wheelmoved(y) end
end

function ScreenshotsScene:textinput(input)
    self.prompt:textinput(input)
end

function ScreenshotsScene:keypressed(key)
    if self.prompt:keypressed(key) or key ~= "escape" then return end

    if self.preview then
        self:_close()
    else
        self.manager:switch(self.exit.scene, self.exit.data)
    end
end

function ScreenshotsScene:draw()
    local previousFont = love.graphics.getFont()

    self.background:draw()
    self.title:draw()
    self.list:draw()
    if #self.shots == 0 then self:_drawEmpty() end
    self.back:draw()
    self.folder:draw()
    if self.preview then self:_drawPreview() end
    self.toast:draw(love.graphics.getHeight() - config.margin * 2)
    self.prompt:draw()
    if not (self.preview or self.prompt.active) then self.folder:drawTooltip(self.tooltip) end

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return ScreenshotsScene
