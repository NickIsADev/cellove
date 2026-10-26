local constants = require("src/constants")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local Display = require("src/engine/graphics/Display")
local utils = require("src/utils")

local config = constants.scene
local colors = constants.ui.colors

local SceneManager = {}
SceneManager.__index = SceneManager
SceneManager.callbacks = config.callbacks.all

function SceneManager.new(data)
    local self = setmetatable({}, SceneManager)
    self.renderer = data.renderer
    self.debug = data.debug
    self.scenes = {}
    self.fade = 0
    self.hold = 0
    self.clock = 0
    return self
end

function SceneManager:_enter(name, data)
    local scene = self.scenes[name]
    local previous = self.current

    if previous and previous.leave then previous:leave() end

    self.current, self.name = scene, name
    if scene.enter then scene:enter(previous, data) end
    Events.emit("scene:enter", name, data)
end

function SceneManager:_drawLoading()
    local renderer = self.renderer
    local w, h = love.graphics.getDimensions()
    local cx, cy = w / 2, h / 2 - 16

    local spinner = renderer.textures.cells[config.loading.spinner.texture]
    local tw, th = spinner:getDimensions()
    local scale = config.loading.spinner.size / tw

    love.graphics.setColor(utils.fromHex(colors.white, self.fade))
    love.graphics.draw(spinner, cx, cy, self.clock * config.loading.spinner.speed, scale, scale, tw / 2, th / 2)

    local font = renderer:font(config.loading.size)
    love.graphics.setFont(font)
    local text = self.pending and self.pending.text or config.loading.text
    love.graphics.print(text, cx - font:getWidth(text) / 2, cy + config.loading.spinner.size / 2 + 24)
end

for _, name in ipairs(config.callbacks.forwarded) do
    local pointer = config.callbacks.pointer[name]

    SceneManager[name] = function(self, ...)
        self.debug:record(name, ...)

        local handler = self.current and self.current[name]
        if not handler then return end
        if pointer then return handler(self.current, Display.point(...)) end
        return handler(self.current, ...)
    end
end

function SceneManager:register(name, scene)
    assert(not self.scenes[name], "duplicate scene " .. name)
    self.scenes[name] = scene
end

function SceneManager:switch(name, data)
    assert(self.scenes[name], "unknown scene " .. name)

    if not self.current then
        self:_enter(name, data)
        self.fade = 1
    elseif not self.pending then
        self.pending = { name = name, data = data }
        self.hold = 0
    end
end

function SceneManager:run(action, text)
    if self.pending then return end

    self.pending = { action = action, text = text }
    self.hold = 0
end

function SceneManager:update(dt)
    self.debug:update(dt)
    dt = math.min(dt, config.maxDelta)
    self.clock = self.clock + dt
    Audio.update()

    if self.pending then
        self.fade = math.min(1, self.fade + dt / config.fade.time)
        if self.fade == 1 then
            self.hold = self.hold + dt
            if self.hold >= config.fade.hold then
                local pending = self.pending
                self.pending = nil
                if pending.action then return pending.action() end
                self:_enter(pending.name, pending.data)
            end
        end
    else
        self.fade = math.max(0, self.fade - dt / config.fade.time)
    end

    local scene = self.current
    if scene and scene.update then scene:update(dt) end
    Events.emit("game:update", dt)
end

function SceneManager:draw()
    love.graphics.push()
    love.graphics.scale(Display.scale)

    local scene = self.current
    if scene and scene.draw then scene:draw() end
    Events.emit("game:draw")

    self.debug:draw(self)

    if self.fade > 0 then
        love.graphics.setColor(0, 0, 0, self.fade)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
        self:_drawLoading()
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.pop()
end

return SceneManager
