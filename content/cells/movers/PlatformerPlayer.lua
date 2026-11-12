local Player = require("content/cells/movers/Player")
local constants = require("src/constants")
local utils = require("src/utils")

local PlatformerPlayer = setmetatable({
    name = "platformerplayer",
    k3 = 614,
    title = "Platformer Player",
    description = "A Player that falls in the direction it faces and steers sideways. Jumps when the opposite direction is held on the ground, as high as its Jump Strength.",
    directional = false,
    properties = {
        { id = "jump", title = "Jump Strength", default = 2, min = 0, max = 99 }
    }
}, { __index = Player })
PlatformerPlayer.__index = PlatformerPlayer

function PlatformerPlayer:new(data)
    local cell = Player.new(self, data)
    cell.vel = { 0, 0 }

    return cell
end

function PlatformerPlayer:_jump(axis, input)
    local gravity = constants.directions[self.rotation]
    local ground = self.grid:get(self.x + gravity[1], self.y + gravity[2])
    local lift = input ~= 0 and input ~= gravity[axis]

    if lift and ground and not ground:eats(gravity[1], gravity[2]) and self.vel[axis] * gravity[axis] >= 0 then
        self.vel[axis] = -gravity[axis] * self.props.jump
    end
end

function PlatformerPlayer:_travel()
    local vel = self.vel
    local left = { math.abs(vel[1]), math.abs(vel[2]) }
    local order = self.rotation % 2 == 0 and { 2, 1 } or { 1, 2 }

    while left[1] > 0 or left[2] > 0 do
        for _, axis in ipairs(order) do
            if left[axis] > 0 then
                local step = { 0, 0 }
                step[axis] = utils.sign(vel[axis])
                left[axis] = left[axis] - 1

                if not self:push(step[1], step[2], constants.force.strength) then
                    vel[axis], left[axis] = 0, 0
                end
                if self.grid:get(self.x, self.y) ~= self then return end
            end
        end
    end
end

function PlatformerPlayer:update()
    local held, vel = self.simulator.held, self.vel
    local gravity = constants.directions[self.rotation]
    local axis = self.rotation % 2 == 0 and 1 or 2
    local side = 3 - axis
    local input = { held[0] and 1 or held[2] and -1 or 0, held[3] and -1 or held[1] and 1 or 0 }

    vel[side] = vel[side] - utils.sign(vel[side]) + input[side]
    vel[1], vel[2] = vel[1] + gravity[1], vel[2] + gravity[2]

    self:_jump(axis, input[axis])
    self:_travel()
end

function PlatformerPlayer:draw(renderer, ...)
    Player.draw(self, renderer, ...)
    renderer:drawTag(self.props.jump, ...)
end

return PlatformerPlayer
