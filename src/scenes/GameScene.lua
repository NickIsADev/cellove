local Simulator = require("src/engine/simulation/Simulator")
local Markers = require("src/engine/simulation/Markers")
local Editor = require("src/editor/Editor")
local Toast = require("src/ui/overlays/Toast")
local constants = require("src/constants")

local config = constants.toast
local text = constants.selector.text.toast
local labels = constants.debug.text.game

local GameScene = {}
GameScene.__index = GameScene

function GameScene.new(data)
    local self = setmetatable({}, GameScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.settings = data.settings
    self.contraptions = data.contraptions
    self.toast = Toast.new(data.renderer)
    self.markers = Markers.new()

    local subticks, rear = data.registry:subticks()
    self.simulator = Simulator.new({ subticks = subticks, rear = rear })
    self.editor = Editor.new({
        simulator = self.simulator,
        renderer = self.renderer,
        registry = data.registry,
        settings = self.settings,
        markers = self.markers,
        contraptions = self.contraptions,
        stamps = data.stamps,
        toast = self.toast,
        menu = {
            export = function() self:_export() end,
            puzzle = function() self:_puzzle() end,
            options = function() self.manager:switch("options", { back = { scene = "game", data = { resume = true } } }) end,
            back = function() self.manager:switch("contraptions", { select = self.name }) end
        }
    })

    self.settings:listen("tickSpeed", function(tickSpeed)
        self.simulator.interval = 1 / tickSpeed
    end)
    return self
end

function GameScene:_snapshot()
    local data = self.simulator:snapshot()
    return {
        width = data.width,
        height = data.height,
        cells = data.cells,
        markers = self.markers.items
    }
end

function GameScene:_save(automatic)
    if not self.name then return end

    local data = self:_snapshot()
    local encoded = self.contraptions:export(data)
    if automatic and encoded == self.checkpoint then return end

    if self.contraptions:save(self.name, data) then
        self.checkpoint = encoded
        if not automatic then self.toast:show(string.format(text.saved, self.name)) end
    else
        self.toast:show(string.format(text.notSaved, self.name), true)
    end
end

function GameScene:_export()
    love.system.setClipboardText(self.contraptions:export(self:_snapshot()))
    self.toast:show(string.format(text.copied, self.name or constants.contraptions.defaultName))
end

function GameScene:_puzzle()
    self.manager:switch("puzzle", {
        name = self.name or constants.contraptions.defaultName,
        data = self:_snapshot(),
        back = { scene = "game", data = { resume = true } }
    })
end

function GameScene:enter(_, data)
    self.toast:clear()
    if data and data.resume then return end

    self.name = data and data.name
    local contraption = self.name and self.contraptions:load(self.name) or self.contraptions:blank()

    self.simulator:load(contraption)
    self.markers:load(contraption.markers)
    self.editor:reset()
    self.renderer.camera:focus(contraption.width, contraption.height)
    self.checkpoint = self.contraptions:export(self:_snapshot())
end

function GameScene:leave()
    self:_save(true)
    self.simulator:pause()
    self.toast:clear()
end

function GameScene:quit()
    self:_save(true)
end

function GameScene:debugInfo()
    local sim, editor, camera = self.simulator, self.editor, self.renderer.camera
    local grid = sim.grid
    local tick, subtick = sim:position()
    local gx, gy = self.renderer.camera:screenToGrid(love.mouse.getPosition())
    local cell = grid:get(gx, gy)

    local count = 0
    for i = 1, grid.width * grid.height do
        if grid.cells[i] then count = count + 1 end
    end

    local lines = {
        string.format(labels.sim, sim.paused and labels.paused or labels.running, tick, subtick, sim.time.pass),
        string.format(labels.speed, sim.interval * 1000, sim:progress() * 100),
        string.format(labels.grid, grid.width, grid.height, count, #sim.dying, #self.renderer.particles.blasts),
        string.format(labels.camera, camera.x, camera.y, camera.zoom, camera.targetZoom),
        string.format(labels.tool, editor.toolId, editor.selected and editor.selected.name or constants.debug.text.none, editor.targetRotation % 4, #editor.history),
        string.format(labels.markers, #self.markers.items, self.name or constants.contraptions.defaultName),
        string.format(labels.cursor, gx, gy)
    }

    if cell then
        local path = cell.path and #cell.path or 0
        lines[#lines + 1] = string.format(labels.cell, getmetatable(cell).name, cell.rotation, cell.turn, path, tostring(cell.updated))
    end
    return lines
end

function GameScene:update(dt)
    self.renderer.camera:update(dt, self.editor:typing())
    self.editor:update(dt)
    self.simulator:update(dt)
    self.toast:update(dt)
end

function GameScene:draw()
    self.renderer:draw(self.simulator, self.simulator:progress(), self.markers.items)
    self.renderer:drawMarkers(self.markers.items)

    self.manager.debug:drawWorld(self.simulator)

    self.editor:draw()
    self.toast:draw(config.top)
end

function GameScene:wheelmoved(x, y)
    if not self.editor:wheelmoved(x, y) then self.renderer.camera:wheelmoved(x, y) end
end

function GameScene:mousepressed(x, y, button)
    self.editor:mousepressed(x, y, button)
end

function GameScene:mousemoved(x, y)
    self.editor:mousemoved(x, y)
end

function GameScene:mousereleased(x, y, button)
    self.editor:mousereleased(x, y, button)
end

function GameScene:textinput(text)
    self.editor:textinput(text)
end

function GameScene:keypressed(key)
    if self.editor:keypressed(key) then return end

    local shift = love.keyboard.isDown("lshift", "rshift")
    local ctrl = love.keyboard.isDown("lctrl", "rctrl")

    if key == "space" then
        self.simulator:toggle()
    elseif key == "f" then
        if shift then self.simulator:substep() else self.simulator:step() end
    elseif key == "r" and ctrl then
        self.simulator:reset()
    elseif key == "s" and ctrl then
        self:_save()
    end
end

return GameScene
