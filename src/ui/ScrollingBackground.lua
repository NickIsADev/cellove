local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.background
local colors = constants.ui.colors

local ScrollingBackground = {}
ScrollingBackground.__index = ScrollingBackground

function ScrollingBackground.new(renderer)
    local self = setmetatable({}, ScrollingBackground)
    self.renderer = renderer
    self.offset = 0
    self.seed = love.math.random(config.logo.seed)
    self.quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)
    return self
end

function ScrollingBackground:_logoAt(column, row)
    local hash, chance, textures = config.logo.hash, config.logo.chance, config.logo.textures
    local value = math.sin(column * hash.column + row * hash.row + self.seed) * hash.scale
    value = value - math.floor(value)

    if value < chance then return math.floor(value / chance * #textures) + 1 end
end

function ScrollingBackground:_drawLogos(tileWidth, tileHeight)
    local renderer = self.renderer
    local w, h = love.graphics.getDimensions()

    local firstColumn = math.floor(self.offset / tileWidth)
    local firstRow = math.floor(self.offset / tileHeight)
    local lastColumn = math.floor((self.offset + w / config.scale) / tileWidth)
    local lastRow = math.floor((self.offset + h / config.scale) / tileHeight)

    for row = firstRow, lastRow do
        for column = firstColumn, lastColumn do
            local index = self:_logoAt(column, row)
            if index then
                local logo = renderer.textures.cells[config.logo.textures[index]]
                local logoWidth, logoHeight = logo:getDimensions()

                love.graphics.draw(logo,
                    (column * tileWidth - self.offset) * config.scale,
                    (row * tileHeight - self.offset) * config.scale,
                    0,
                    tileWidth * config.scale / logoWidth,
                    tileHeight * config.scale / logoHeight)
            end
        end
    end
end

function ScrollingBackground:update(dt)
    self.offset = self.offset + dt * config.speed
end

function ScrollingBackground:draw()
    local renderer = self.renderer
    local w, h = love.graphics.getDimensions()
    local background = renderer.textures.ui.background
    local tileWidth, tileHeight = background:getDimensions()

    background:setWrap("repeat", "repeat")
    self.quad:setViewport(self.offset, self.offset, w / config.scale, h / config.scale, tileWidth, tileHeight)

    love.graphics.clear(utils.fromHex(colors.dark))
    love.graphics.setColor(utils.fromHex(colors.white, config.alpha))
    love.graphics.draw(background, self.quad, 0, 0, 0, config.scale, config.scale)
    self:_drawLogos(tileWidth, tileHeight)
    love.graphics.setColor(utils.fromHex(colors.white))
end

return ScrollingBackground
