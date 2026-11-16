local constants = require("src/constants")
local utils = require("src/utils")

local blast = constants.renderer.explosion
local spark = constants.renderer.spark
local tile = constants.grid.tile
local colors = constants.ui.colors

local Particles = {}
Particles.__index = Particles

local function system(texture, kind)
    local built = love.graphics.newParticleSystem(texture)

    built:setColors(unpack(kind.colors))
    built:setSizes(kind.size * spark.scale, 0)
    built:setSizeVariation(1)
    built:setSpread(2 * math.pi)
    built:setSpeed(0, spark.speed * spark.scale)
    built:setParticleLifetime(unpack(spark.life))
    built:setEmissionArea("uniform", spark.area * spark.scale, spark.area * spark.scale)
    built:setLinearDamping(1)
    built:setBufferSize(1000)
    return built
end

function Particles.new(sprite)
    local self = setmetatable({}, Particles)
    self.sprite = sprite
    self.blasts = {}
    self.blasted = setmetatable({}, { __mode = "k" })
    self.systems = {}
    return self
end

function Particles:spark(cell)
    if not self.enabled or cell.sparked then return end

    local kind = spark.kinds[cell.spark]
    local emitter = self.systems[cell.spark] or system(self.sprite(spark.texture, spark.folder), kind)

    self.systems[cell.spark] = emitter
    cell.sparked = true
    emitter:setPosition((cell.x - 0.5) * tile, (cell.y - 0.5) * tile)
    emitter:emit(kind.count)
end

function Particles:burst(x, y, palette)
    if not self.enabled then return end
    if not (palette and #palette > 0) then palette = blast.colors end

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
    local step = math.min(now - (self.clock or now), 0.1)

    self.clock = now
    for _, emitter in pairs(self.systems) do
        emitter:update(step)
        love.graphics.setColor(utils.fromHex(colors.white))
        love.graphics.draw(emitter)
    end

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

                love.graphics.setColor(utils.fromHex(item.colors[i], 1 - t))
                love.graphics.rectangle("fill", x + math.cos(angle) * distance - size / 2, y + math.sin(angle) * distance - size / 2, size, size)
            end
        end
    end
    love.graphics.setColor(utils.fromHex(colors.white))
end

return Particles
