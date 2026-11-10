local constants = require("src/constants")
local utils = require("src/utils")

local view = constants.camera
local tile = constants.grid.tile

local Camera = {}
Camera.__index = Camera

function Camera.new(data)
    local self = setmetatable({}, Camera)
    self.hotkeys = data.hotkeys
    self.size = data.size or love.graphics.getDimensions
    self.x = 0
    self.y = 0
    self.vx = 0
    self.vy = 0
    self.zoom = view.zoom.default
    self.targetZoom = view.zoom.default
    return self
end

function Camera:_world(sx, sy)
    local width, height = self.size()
    return (sx - width / 2) / self.zoom + self.x, (sy - height / 2) / self.zoom + self.y
end

function Camera:apply()
    local width, height = self.size()

    love.graphics.translate(width / 2, height / 2)
    love.graphics.scale(self.zoom)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:screenToTile(sx, sy)
    local wx, wy = self:_world(sx, sy)
    return wx / tile + 0.5, wy / tile + 0.5
end

function Camera:screenToGrid(sx, sy)
    local x, y = self:screenToTile(sx, sy)
    return math.floor(x + 0.5), math.floor(y + 0.5)
end

function Camera:gridToScreen(gx, gy)
    local width, height = self.size()
    local x, y = (gx - 1) * tile - self.x, (gy - 1) * tile - self.y

    return width / 2 + x * self.zoom, height / 2 + y * self.zoom
end

function Camera:focus(width, height)
    self.x, self.y = width * tile / 2, height * tile / 2
    self.vx, self.vy = 0, 0
    self.zoom, self.targetZoom = view.zoom.default, view.zoom.default
end

function Camera:update(dt, locked, gx, gy)
    local ix, iy = 0, 0
    if not (locked or gx or love.keyboard.isDown("lctrl", "rctrl")) then
        if self.hotkeys:down("moveUp") then iy = iy - 1 end
        if self.hotkeys:down("moveDown") then iy = iy + 1 end
        if self.hotkeys:down("moveLeft") then ix = ix - 1 end
        if self.hotkeys:down("moveRight") then ix = ix + 1 end
    end

    if ix ~= 0 or iy ~= 0 then self.pin = nil end

    local speed = view.speed / self.zoom
    local ease = math.min(1, view.ease * dt)

    self.vx = utils.lerp(self.vx, ix * speed, ease)
    self.vy = utils.lerp(self.vy, iy * speed, ease)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    local zoom = view.zoom
    self.zoom = utils.lerp(self.zoom, self.targetZoom, math.min(1, zoom.ease * dt))

    local settled = math.abs(self.zoom - self.targetZoom) < self.targetZoom * zoom.settle
    if settled then self.zoom = self.targetZoom end

    if gx then
        self.pin = nil
        self.x = utils.lerp(self.x, (gx - 0.5) * tile, ease)
        self.y = utils.lerp(self.y, (gy - 0.5) * tile, ease)
        return
    end

    local pin = self.pin
    if not pin then return end

    local width, height = self.size()
    self.x = pin.wx - (pin.sx - width / 2) / self.zoom
    self.y = pin.wy - (pin.sy - height / 2) / self.zoom
    if settled then self.pin = nil end
end

function Camera:grab(x, y)
    self.grip = { x = x, y = y, moved = false }
end

function Camera:drag(x, y)
    local grip = self.grip
    if not (grip and love.mouse.isDown(3)) then return end
    if not grip.moved and math.abs(x - grip.x) + math.abs(y - grip.y) < view.threshold then return end

    grip.moved, self.pin = true, nil
    self.x = self.x - (x - grip.x) / self.zoom
    self.y = self.y - (y - grip.y) / self.zoom
    grip.x, grip.y = x, y
end

function Camera:release()
    local grip = self.grip
    self.grip = nil
    return grip
end

function Camera:wheelmoved(_, y)
    local zoom = view.zoom
    local sx, sy = love.mouse.getPosition()
    local wx, wy = self:_world(sx, sy)

    if y > 0 then
        self.targetZoom = self.targetZoom * zoom.step
    elseif y < 0 then
        self.targetZoom = self.targetZoom / zoom.step
    end
    self.targetZoom = utils.clamp(self.targetZoom, zoom.min, zoom.max)
    self.pin = { sx = sx, sy = sy, wx = wx, wy = wy }
end

return Camera
