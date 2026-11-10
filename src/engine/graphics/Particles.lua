local constants = require("src/constants")
local utils = require("src/utils")

local blast = constants.renderer.explosion
local tile = constants.grid.tile
local colors = constants.ui.colors
local fallback = {}

for i, hex in ipairs(blast.colors) do
    fallback[i] = { utils.fromHex(hex) }
end

local Particles = {}
Particles.__index = Particles

function Particles.new()
    local self = setmetatable({}, Particles)
    self.blasts = {}
    self.blasted = setmetatable({}, { __mode = "k" })
    return self
end

function Particles:burst(x, y, palette)
    if not self.enabled then return end
    if not (palette and #palette > 0) then palette = fallback end

    local item = { x = x, y = y, start = love.timer.getTime(), colors = {} }

    for i = 1, blast.count do
        item.colors[i] = palette[love.math.random(#palette)]
    end
    self.blasts[#self.blasts + 1] = item
end

function Particles:blast(cell, progress, palette)
    local start = self.blasted[cell]

    if not start and progress >= 0.5 then
        start = love.timer.getTime()
        self.blasted[cell] = start
        self:burst(cell.x, cell.y, palette)
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
                local color = item.colors[i]

                love.graphics.setColor(color[1], color[2], color[3], 1 - t)
                love.graphics.rectangle("fill", x + math.cos(angle) * distance - size / 2, y + math.sin(angle) * distance - size / 2, size, size)
            end
        end
    end
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Particles
