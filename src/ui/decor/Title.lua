local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.title
local shadow = constants.ui.shadow

local Title = {}
Title.__index = Title

function Title.new(renderer, data)
    local self = setmetatable({}, Title)
    self.renderer = renderer
    self.text = data.text
    self.size = data.size
    return self
end

function Title:draw()
    local font = self.renderer:font(self.size)
    local w, h = love.graphics.getDimensions()
    local x = (w - font:getWidth(self.text)) / 2
    local y = h * config.y - font:getHeight() / 2

    love.graphics.setFont(font)
    utils.drawShadowed(function(ox, oy)
        love.graphics.print(self.text, x + ox, y + oy)
    end, shadow.offset, shadow.alpha)
end

return Title
