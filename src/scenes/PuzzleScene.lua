local Victory = require("src/ui/overlays/Victory")
local PauseMenu = require("src/editor/panels/PauseMenu")
local Controls = require("src/editor/panels/Controls")
local Puzzle = require("src/engine/simulation/Puzzle")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.puzzles
local colors = constants.ui.colors
local shadow = constants.ui.shadow

local PuzzleScene = {}
PuzzleScene.__index = PuzzleScene

function PuzzleScene.new(data)
    local self = setmetatable({}, PuzzleScene)
    self.manager = data.manager
    self.renderer = data.renderer
    self.puzzles = data.puzzles
    self.progress = data.progress
    self.puzzle = Puzzle.new({ registry = data.registry, settings = data.settings })
    self.simulator = self.puzzle.simulator
    self.controls = Controls.new(data.renderer, self.simulator, config.hidden)
    self.victory = Victory.new(data.renderer)
    self.pauseMenu = PauseMenu.new({
        renderer = data.renderer,
        layout = "puzzle",
        onOpen = function() self.simulator:pause() end,
        actions = {
            reset = function() self:_reset() end,
            options = function() self.manager:switch("options", { back = { scene = "puzzle", data = { resume = true } } }) end,
            back = function() self:_exit() end
        }
    })
    self.cleared = false
    return self
end

function PuzzleScene:_exit()
    self.manager:switch(self.back.scene, self.back.data)
end

function PuzzleScene:_reset()
    self.puzzle:load(self.info.data)
    self.timer, self.cleared = nil, false
end

function PuzzleScene:_locked()
    return self.victory.active or self.pauseMenu.active
end

function PuzzleScene:_win()
    local id = self.info.id
    local following = id and self.puzzles:after(id)

    self.timer, self.cleared = nil, true
    if id then self.progress:complete(id) end
    Events.emit("puzzle:solved", self.info)
    self.victory:open({
        name = self.info.name,
        actions = {
            replay = function()
                self.victory:close()
                self:_reset()
            end,
            puzzles = function() self:_exit() end,
            next = following and function() self.manager:switch("puzzle", { id = following.id }) end
        }
    })
end

function PuzzleScene:_watch(dt)
    if not self.simulator:started() then
        self.timer, self.cleared = nil, false
    elseif self.timer then
        self.timer = self.timer - dt
        if self.timer <= 0 then self:_win() end
    elseif not self.cleared and self.puzzle:solved() then
        self.timer = self.simulator.interval + config.delay
        self.simulator:pause()
    end
end

function PuzzleScene:_drawHeld()
    local held, renderer = self.puzzle.held, self.renderer
    if not held then return end

    local x, y = renderer:screenToTile(love.mouse.getPosition())

    renderer:drawGhost(held.cell.texture, x, y, held.cell.rotation, config.held.alpha)
end

function PuzzleScene:_drawEnemies()
    local hud, renderer = config.hud, self.renderer
    local font, icon = renderer:font(hud.count), renderer.textures.cells.enemy
    local count = tostring(self.puzzle:remaining())
    local y = love.graphics.getHeight() - hud.margin - hud.icon

    love.graphics.setFont(font)
    utils.drawShadowed(function(ox, oy)
        love.graphics.draw(icon, hud.margin + ox, y + oy, 0, hud.icon / icon:getWidth(), hud.icon / icon:getHeight())
        love.graphics.print(count, hud.margin + hud.icon + hud.gap + ox, y + (hud.icon - font:getHeight()) / 2 + oy)
    end, shadow.offset, shadow.alpha)
end

function PuzzleScene:_drawHud()
    local hud = config.hud
    local title, detail = self.renderer:font(hud.title), self.renderer:font(hud.detail)
    local x = (love.graphics.getWidth() - hud.width) / 2
    local previousFont = love.graphics.getFont()

    love.graphics.setFont(title)
    utils.drawShadowed(function(ox, oy)
        love.graphics.printf(self.info.name, x + ox, hud.margin + oy, hud.width, "center")
    end, shadow.offset, shadow.alpha)

    love.graphics.setFont(detail)
    love.graphics.printf(utils.colored(self.info.tip or "", { utils.fromHex(colors.white, 0.7) }),
        x, hud.margin + title:getHeight() + hud.gap, hud.width, "center")

    self:_drawEnemies()

    love.graphics.setFont(previousFont)
    love.graphics.setColor(utils.fromHex(colors.white))
end

function PuzzleScene:enter(_, data)
    if data.resume then return end

    self.info = data.id and self.puzzles:get(data.id) or data
    self.back = data.back or { scene = "puzzles", data = { select = data.id } }

    self.pauseMenu:setLayout(data.back and "custom" or "puzzle")
    self:_reset()
    self.renderer:focus(self.info.data.width, self.info.data.height)
end

function PuzzleScene:leave()
    self.puzzle:cancel()
    self.simulator:pause()
    self.victory:close()
    self.pauseMenu:close()
end

function PuzzleScene:update(dt)
    self.renderer:update(dt, self:_locked())
    self.simulator:update(dt)
    self:_watch(dt)
    self.pauseMenu:update(dt)
    self.victory:update(dt)
end

function PuzzleScene:mousepressed(x, y, button)
    if self.victory:mousepressed(x, y, button) or self.pauseMenu:mousepressed(x, y, button) or button ~= 1 then return end

    local control = self.controls:buttonAt(x, y)
    if control then
        Audio.play("click")
        return self.simulator[control](self.simulator)
    end

    self.puzzle:lift(self.renderer:screenToGrid(x, y))
end

function PuzzleScene:mousemoved(x, y)
    self.pauseMenu:mousemoved(x, y)
end

function PuzzleScene:mousereleased(x, y, button)
    if button ~= 1 or not self.puzzle.held then return end

    Audio.play("click")
    self.puzzle:drop(self.renderer:screenToGrid(x, y))
end

function PuzzleScene:wheelmoved(x, y)
    if not self:_locked() then self.renderer:wheelmoved(x, y) end
end

function PuzzleScene:keypressed(key)
    if self.victory:keypressed(key) or self.pauseMenu:keypressed(key) or self.puzzle.held then return end

    if key == "escape" then
        self.pauseMenu:open()
    elseif key == "space" then
        self.simulator:toggle()
    elseif key == "f" then
        self.simulator:step()
    elseif key == "r" and love.keyboard.isDown("lctrl", "rctrl") then
        self.simulator:reset()
    end
end

function PuzzleScene:draw()
    local markers = self.puzzle.markers.items

    self.renderer:draw(self.simulator, self.simulator:progress(), markers)
    self.renderer:drawMarkers(markers)
    self:_drawHeld()
    self:_drawHud()
    self.controls:draw()
    self.pauseMenu:draw()
    self.victory:draw()
end

return PuzzleScene
