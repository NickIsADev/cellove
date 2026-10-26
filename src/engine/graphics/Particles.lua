local constants = require("src/constants")
local utils = require("src/utils")

local blast = constants.renderer.explosion
local tile = constants.grid.tile
local colors = constants.ui.colors

local Particles = {}
Particles.__index = Particles

function Particles.new()
    local self = setmetatable({}, Particles)
    self.blasts = {}
    self.blasted = setmetatable({}, { __mode = "k" })
    return self
end

function Particles:blast(cell, progress)
    local start = self.blasted[cell]

    if not start and progress >= 0.5 then
        start = love.timer.getTime()
        self.blasted[cell] = start
        if self.enabled then
            self.blasts[#self.blasts + 1] = {
                x = cell.x,
                y = cell.y,
                start = start
            }
        end
    end
    return start and (love.timer.getTime() - start) / blast.pop or 0
end

function Particles:draw()
    local now = love.timer.getTime()

    for index = #self.blasts, 1, -1 do
        local item = self.blasts[index]
        local t = (now - item.start) / blast.time

        if t >= 1 then
            table.remove(self.blasts, index)
        else
            local x, y = (item.x - 0.5) * tile, (item.y - 0.5) * tile
            local size = blast.size * (1 - t)
            local reach = blast.distance * tile * (1 - (1 - t) ^ 3)

            for i = 1, blast.count do
                local angle = i * 2 * math.pi / blast.count + i * i
                local distance = reach * (0.5 + (i * 0.618) % 0.5)

                love.graphics.setColor(utils.fromHex(blast.colors[i % #blast.colors + 1], 1 - t))
                love.graphics.rectangle("fill", x + math.cos(angle) * distance - size / 2, y + math.sin(angle) * distance - size / 2, size, size)
            end
        end
    end
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Particles
