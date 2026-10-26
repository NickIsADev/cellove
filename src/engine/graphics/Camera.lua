local constants = require("src/constants")
local utils = require("src/utils")

local view = constants.camera
local tile = constants.grid.tile

local Camera = {}
Camera.__index = Camera

function Camera.new()
    local self = setmetatable({}, Camera)
    self.x = 0
    self.y = 0
    self.vx = 0
    self.vy = 0
    self.zoom = view.zoom.default
    self.targetZoom = view.zoom.default
    return self
end

function Camera:apply()
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.scale(self.zoom)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:screenToTile(sx, sy)
    local wx = (sx - love.graphics.getWidth() / 2) / self.zoom + self.x
    local wy = (sy - love.graphics.getHeight() / 2) / self.zoom + self.y
    return wx / tile + 0.5, wy / tile + 0.5
end

function Camera:screenToGrid(sx, sy)
    local x, y = self:screenToTile(sx, sy)
    return math.floor(x + 0.5), math.floor(y + 0.5)
end

function Camera:focus(width, height)
    self.x, self.y = width * tile / 2, height * tile / 2
    self.vx, self.vy = 0, 0
    self.zoom, self.targetZoom = view.zoom.default, view.zoom.default
end

function Camera:update(dt, locked)
    local ix, iy = 0, 0
    if not (locked or love.keyboard.isDown("lctrl", "rctrl")) then
        if love.keyboard.isDown("w") then iy = iy - 1 end
        if love.keyboard.isDown("s") then iy = iy + 1 end
        if love.keyboard.isDown("a") then ix = ix - 1 end
        if love.keyboard.isDown("d") then ix = ix + 1 end
    end

    local speed = view.speed / self.zoom
    local ease = math.min(1, view.ease * dt)

    self.vx = utils.lerp(self.vx, ix * speed, ease)
    self.vy = utils.lerp(self.vy, iy * speed, ease)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    self.zoom = utils.lerp(self.zoom, self.targetZoom, math.min(1, view.zoom.ease * dt))
end

function Camera:wheelmoved(_, y)
    local zoom = view.zoom

    if y > 0 then
        self.targetZoom = self.targetZoom * zoom.step
    elseif y < 0 then
        self.targetZoom = self.targetZoom / zoom.step
    end
    self.targetZoom = utils.clamp(self.targetZoom, zoom.min, zoom.max)
end

return Camera
