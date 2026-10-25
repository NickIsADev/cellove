local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local Widget = {}
Widget.__index = Widget

function Widget:setup(data)
    self.renderer = data.renderer
    self.enabled = true
    self.hover = 0
    self.x, self.y = 0, 0
    self.width, self.height = data.width or 0, data.height or 0
end

function Widget:place(x, y, width, height)
    self.x, self.y = x, y
    self.width = width or self.width
    self.height = height or self.height
end

function Widget:contains(x, y)
    return utils.inside(x, y, self.x, self.y, self.width, self.height)
end

function Widget:hit(x, y)
    if not (self.enabled and self:contains(x, y)) then return false end

    Audio.play("click")
    return true
end

function Widget:update(dt)
    local target = not Widget.blocked and self.enabled and self:contains(love.mouse.getPosition()) and 1 or 0
    self.hover = utils.lerp(self.hover, target, math.min(1, constants.ui.hover.speed * dt))
end

return Widget
