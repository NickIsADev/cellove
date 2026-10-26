local Toolbar = require("src/editor/panels/Toolbar")
local ToolPanel = require("src/editor/panels/ToolPanel")
local PropertyPanel = require("src/editor/panels/PropertyPanel")
local Library = require("src/editor/panels/Library")
local StampList = require("src/editor/panels/StampList")
local ToolMenu = require("src/editor/panels/ToolMenu")
local PauseMenu = require("src/editor/panels/PauseMenu")
local Controls = require("src/editor/panels/Controls")
local Brush = require("src/editor/tools/Brush")
local Selector = require("src/editor/tools/Selector")
local Marker = require("src/editor/tools/Marker")
local Prompt = require("src/ui/overlays/Prompt")
local ColorPicker = require("src/ui/overlays/ColorPicker")
local Fresh = require("src/engine/data/Fresh")
local Markers = require("src/engine/simulation/Markers")
local Properties = require("src/engine/registry/Properties")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor
local colors = constants.ui.colors

local tools = {
    brush = Brush,
    selector = Selector,
    marker = Marker
}

local function same(a, b)
    if not (a and b) then return a == b end
    return a.class == b.class and a.rotation == b.rotation and utils.same(a.props, b.props)
end

local Editor = {}
Editor.__index = Editor

function Editor.new(data)
    local self = setmetatable({}, Editor)
    self.simulator = data.simulator
    self.registry = data.registry
    self.renderer = data.renderer
    self.settings = data.settings
    self.markers = data.markers
    self.contraptions = data.contraptions
    self.stamps = data.stamps
    self.toast = data.toast
    self.prompt = Prompt.new(data.renderer)
    self.picker = ColorPicker.new(data.renderer)
    self.controls = Controls.new(data.renderer, data.simulator)
    self.panel = ToolPanel.new(data.renderer)
    self.properties = PropertyPanel.new(data.renderer)

    self.pauseMenu = PauseMenu.new({
        renderer = data.renderer,
        layout = "editor",
        onOpen = function() self.simulator:pause() end,
        actions = {
            resize = function() self:_askResize() end,
            clear = function() self:_askClear() end,
            export = data.menu.export,
            puzzle = data.menu.puzzle,
            options = data.menu.options,
            back = data.menu.back
        }
    })
    self.toolMenu = ToolMenu.new({ renderer = data.renderer, onPick = function(id) self:setTool(id) end })
    self.fresh = Fresh.new({ registry = data.registry, settings = data.settings })
    self.toolbar = Toolbar.new({
        renderer = data.renderer,
        registry = data.registry,
        settings = data.settings,
        fresh = self.fresh,
        on = {
            cell = function(class) self:select(self.selected ~= class and class or nil) end,
            menu = function() self.toolMenu:open(self.toolId) end,
            library = function() self.library:open() end
        }
    })
    self.library = Library.new({
        renderer = data.renderer,
        registry = data.registry,
        toolbar = self.toolbar,
        prompt = self.prompt,
        fresh = self.fresh,
        onPick = function(class) self:select(class) end
    })
    self.stampList = StampList.new({
        renderer = data.renderer,
        stamps = data.stamps,
        prompt = self.prompt,
        onPick = function(stamp) self.tools.selector:load(stamp) end
    })

    self.tools = {}
    self.keys = {}
    for _, tool in ipairs(config.tools.list) do
        self.tools[tool.id] = (tool.class or tools[tool.id]).new(self)
        if tool.key then self.keys[tool.key] = tool.id end
    end

    self.actions = { initial = self._setInitial }

    self:reset()
    return self
end

function Editor:_capture(x, y)
    local cell = self.simulator.grid:get(x, y)
    return cell and { class = getmetatable(cell), rotation = cell.rotation, props = cell.props }
end

function Editor:_restore(x, y, state)
    self.simulator.grid:set(x, y, state and state.class:new({ rotation = state.rotation, props = state.props }))
end

function Editor:_record(undo)
    self.stroke = self.stroke or {}
    self.stroke[#self.stroke + 1] = undo
end

function Editor:_undo()
    local stroke = table.remove(self.history)
    if not stroke then return end

    for i = #stroke, 1, -1 do
        stroke[i]()
    end
    self.simulator:save()
end

function Editor:_overUi(x, y)
    return self.toolbar:contains(x, y) or self.panel:contains(x, y) or self.properties:contains(x, y) or self.pauseMenu:contains(x, y) or self.controls:buttonAt(x, y)
end

function Editor:_drawLabel()
    local label = config.label
    local previousFont = love.graphics.getFont()
    local tick, subtick, pass = self.simulator:position()
    local font = self.renderer:font(label.font)

    love.graphics.setFont(font)
    love.graphics.setColor(utils.fromHex(colors.white, label.alpha))

    local y = label.margin
    if self.settings:get("showFps") then
        love.graphics.print(string.format(label.fps, love.timer.getFPS()), label.left, y)
        y = y + font:getHeight()
    end
    love.graphics.print(string.format(self.simulator.paused and pass > 0 and label.pass or label.tick, tick, subtick, pass), label.left, y)

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function Editor:_askClear()
    local text = config.grid.text.clear

    self.prompt:open({
        title = text.title,
        message = text.message,
        confirm = text.confirm,
        onConfirm = function() self:_clearGrid() end
    })
end

function Editor:_clearGrid()
    local grid, markers, text = self.simulator.grid, self.markers, config.grid.text.clear
    local saved, items = grid:snapshot().cells, markers.items
    if #saved == 0 and #items == 0 then return self.toast:show(text.empty, true) end

    grid:clear()
    markers:load({})
    self:_record(function()
        self.simulator.grid:populate(saved)
        markers:load(items)
    end)
    self:commit()
    self.toast:show(text.done)
end

function Editor:_askResize()
    local grid, text = self.simulator.grid, config.grid.text.resize
    local limits = constants.grid.limits

    self.prompt:open({
        title = text.title,
        message = text.message .. (self.simulator:started() and text.restart or ""),
        confirm = text.confirm,
        fields = {
            {
                key = "width",
                label = text.width,
                min = limits.min,
                max = limits.max,
                value = grid.width
            },
            {
                key = "height",
                label = text.height,
                min = limits.min,
                max = limits.max,
                value = grid.height
            }
        },
        onConfirm = function(_, values) self:_resizeGrid(values.width, values.height) end
    })
end

function Editor:_resizeGrid(width, height)
    local sim, markers, text = self.simulator, self.markers, config.grid.text.resize
    local grid = sim.grid
    local old = { width = grid.width, height = grid.height }

    if width == old.width and height == old.height then return self.toast:show(text.same, true) end

    if sim:started() then sim:reset() end

    local cells, items, kept = {}, {}, {}
    for _, entry in ipairs(grid:snapshot().cells) do
        if entry.x > width or entry.y > height then cells[#cells + 1] = entry end
    end
    for _, marker in ipairs(markers.items) do
        local x2, y2 = Markers.extent(marker)
        local list = (x2 > width or y2 > height) and items or kept
        list[#list + 1] = marker
    end

    grid:reshape(width, height)
    markers:load(kept)
    sim:save()

    self:_record(function()
        if sim:started() then sim:reset() end
        sim.grid:reshape(old.width, old.height)
        sim.grid:populate(cells)
        for _, marker in ipairs(items) do markers.items[#markers.items + 1] = marker end
        self.renderer.camera:focus(old.width, old.height)
    end)
    self:commit()

    self.renderer.camera:focus(width, height)
    self.toast:show(string.format(text.done, width, height))
end

function Editor:_setInitial()
    self.simulator.grid:save()
    self.simulator:reset()
    self.history, self.stroke = {}, nil
    self.toast:show(config.grid.text.initial.done)
end

function Editor:_pick(gx, gy)
    local cell = self.simulator.grid:get(gx, gy)
    if not cell then return end

    self:select(getmetatable(cell))
    self.targetRotation = self.targetRotation + (cell.rotation - self.targetRotation + 2) % 4 - 2
    self.properties:load(getmetatable(cell), cell.props)
end

function Editor:_edit(gx, gy)
    local cell = self.simulator.grid:get(gx, gy)
    local class = cell and getmetatable(cell)
    if not (class and #class.properties > 0) then return false end

    self.prompt:open({
        title = class.title,
        icon = class.texture,
        fields = Properties.specs(class.properties, cell.props),
        onConfirm = function(_, props)
            self:setCell(gx, gy, { class = class, rotation = cell.rotation, props = props })
            self:commit()
        end
    })
    return true
end

function Editor:select(class)
    self.selected = class
    if class then self:setTool("brush") end
end

function Editor:setTool(id)
    if self.tool then self.tool:leave() end

    self.tool = self.tools[id]
    self.toolId = id
    self.panel:set(self.tool)
    self.toolbar:setTool(id)
end

function Editor:setCell(x, y, state)
    local before = self:_capture(x, y)
    if not self.simulator.grid:bounds(x, y) or same(before, state) then return false end

    self:_restore(x, y, state)
    self:_record(function() self:_restore(x, y, before) end)
    return true
end

function Editor:setMarker(x, y, marker)
    if not self.simulator.grid:bounds(x, y) then return false end

    local before = self.markers:at(x, y)
    self.markers:set(x, y, marker)
    self:_record(function() self.markers:set(x, y, before) end)
    return true
end

function Editor:addArea(area)
    local grid = self.simulator.grid
    local x2, y2 = Markers.extent(area)
    if not (grid:bounds(area.x, area.y) and grid:bounds(x2, y2)) then return false end

    self.markers:add(area)
    self:_record(function() self.markers:remove(area) end)
    return true
end

function Editor:removeArea(area)
    self.markers:remove(area)
    self:_record(function() self.markers:add(area) end)
end

function Editor:setPlaceable(x, y, enabled)
    local existing = self.markers:placeableAt(x, y)
    if not self.simulator.grid:bounds(x, y) or (existing ~= nil) == enabled then return end

    if enabled then
        self:addArea({ kind = "placeable", x = x, y = y })
    else
        self:removeArea(existing)
    end
end

function Editor:commit()
    local stroke = self.stroke
    self.stroke = nil
    if not stroke then return end

    self.history[#self.history + 1] = stroke
    if #self.history > config.history.max then table.remove(self.history, 1) end
    self.simulator:save()
    Events.emit("editor:commit", self)
end

function Editor:typing()
    return self.library.active or self.stampList.active or self.prompt.active or self.picker.active or self.toolMenu.active or self.pauseMenu.active or self.properties:typing()
end

function Editor:reset()
    self.history = {}
    self.stroke = nil
    self.drag = nil
    self.selected = nil
    self.targetRotation, self.visualRotation = 0, 0

    for _, tool in pairs(self.tools) do
        tool:reset()
    end
    self:setTool(config.tools.default)
    self.toolbar:reset()
    if self.library.active then self.library:close() end
    if self.stampList.active then self.stampList:close() end
    if self.picker.active then self.picker:close() end
    self.toolMenu:close()
    self.pauseMenu:close()
    self.properties:reset()
end

function Editor:update(dt)
    self.prompt:update(dt)
    self.picker:update(dt)
    self.library:update(dt)
    self.stampList:update(dt)
    self.toolMenu:update(dt)
    self.pauseMenu:update(dt)
    self.toolbar:update(dt)
    self.panel:update(dt)
    self.properties:update(dt, self.toolId == "brush" and self.selected or nil)

    if math.abs(self.targetRotation - self.visualRotation) < 0.001 then
        self.visualRotation = self.targetRotation
    else
        self.visualRotation = utils.lerp(self.visualRotation, self.targetRotation, math.min(1, config.rotationEase * dt))
    end
end

function Editor:keypressed(key)
    if self.prompt:keypressed(key) or self.picker:keypressed(key) or self.library:keypressed(key) or self.stampList:keypressed(key) or self.toolMenu:keypressed(key) or self.pauseMenu:keypressed(key) or self.properties:keypressed(key) then return true end

    local ctrl = love.keyboard.isDown("lctrl", "rctrl")
    local tool = self.keys[key]

    if self.tool:keypressed(key) then
        return true
    elseif key == "escape" then
        self.pauseMenu:open()
    elseif key == "tab" then
        self.library:open()
    elseif key == "`" then
        self.toolMenu:open(self.toolId)
    elseif ctrl and key == "z" then
        self:_undo()
    elseif tool and not ctrl then
        if not self.drag and tool ~= self.toolId then self:setTool(tool) end
    else
        if not ctrl then self.targetRotation = self.targetRotation + (config.turns[key] or 0) end
        return false
    end
    return true
end

function Editor:textinput(text)
    self.prompt:textinput(text)
    self.picker:textinput(text)
    self.library:textinput(text)
    self.properties:textinput(text)
end

function Editor:wheelmoved(x, y)
    if self.library:wheelmoved(x, y) or self.stampList:wheelmoved(x, y) or self.prompt.active or self.picker.active or self.toolMenu.active or self.pauseMenu.active then return true end
    return love.keyboard.isDown("lctrl", "rctrl") and self.tool:wheel(y)
end

function Editor:mousepressed(x, y, button)
    if self.prompt:mousepressed(x, y, button) or self.picker:mousepressed(x, y, button) or self.library:mousepressed(x, y, button) or self.stampList:mousepressed(x, y, button) or self.toolMenu:mousepressed(x, y, button) or self.pauseMenu:mousepressed(x, y, button) then return true end

    local control = self.controls:buttonAt(x, y)
    if control then
        if button == 1 then
            Audio.play("click")
            local action = self.actions[control]
            if action then action(self) else self.simulator[control](self.simulator) end
        end
        return true
    end

    if self.properties:mousepressed(x, y, button) or self.toolbar:mousepressed(x, y, button) or self.panel:mousepressed(x, y, button) then return true end

    local gx, gy = self.renderer.camera:screenToGrid(x, y)
    if button == 3 then
        self.renderer.camera:grab(x, y)
        return true
    end

    if button == 1 and love.keyboard.isDown("lshift", "rshift") and self:_edit(gx, gy) then return true end

    self.drag = self.tool:press(gx, gy, button) and button
    if not self.drag then self:commit() end
    return true
end

function Editor:mousemoved(x, y)
    self.prompt:mousemoved(x, y)
    self.picker:mousemoved(x, y)
    self.toolbar:mousemoved(x, y)
    self.toolMenu:mousemoved(x, y)
    self.pauseMenu:mousemoved(x, y)
    self.library:mousemoved(x, y)
    self.stampList:mousemoved(x, y)
    self.panel:mousemoved(x, y)
    self.properties:mousemoved(x, y)
    self.renderer.camera:drag(x, y)

    if self.drag then self.tool:move(self.renderer.camera:screenToGrid(x, y)) end
end

function Editor:mousereleased(x, y, button)
    self.prompt:mousereleased(x, y, button)
    self.picker:mousereleased()
    self.toolbar:mousereleased(x, y, button)
    self.library:mousereleased()
    self.stampList:mousereleased()
    self.panel:mousereleased(x, y, button)
    self.properties:mousereleased(x, y, button)

    if button == 3 then
        local camera = self.renderer.camera
        local grip = camera:release()
        if grip and not grip.moved then self:_pick(camera:screenToGrid(x, y)) end
    end

    if button ~= self.drag then return end

    self.tool:release(self.renderer.camera:screenToGrid(x, y))
    self.drag = nil
    self:commit()
end

function Editor:draw()
    local mx, my = love.mouse.getPosition()
    local gx, gy
    if not (self:typing() or self:_overUi(mx, my)) then
        gx, gy = self.renderer.camera:screenToGrid(mx, my)
    end

    self.tool:draw(gx, gy)
    self.toolbar:draw(self.selected, self.visualRotation)
    self.panel:draw()
    self.properties:draw()
    self.controls:draw()
    self.toolbar:drawTooltip()
    self.panel:drawTooltip()
    self:_drawLabel()
    self.pauseMenu:draw()
    self.toolMenu:draw()
    self.library:draw()
    self.stampList:draw()
    self.prompt:draw()
    self.picker:draw()
end

return Editor
