local constants = require("src/constants")

local config = constants.window.icon

local Window = {}
Window.__index = Window

function Window.new(data)
    local self = setmetatable({}, Window)
    self.texturePacks = data.texturePacks

    data.settings:listen("packs", function() self:_applyIcon() end)
    data.settings:listen("fullscreen", function(fullscreen) love.window.setFullscreen(fullscreen) end)
    data.settings:listen("vsync", function(vsync) love.window.setVSync(vsync and 1 or 0) end)
    return self
end

function Window:_applyIcon()
    local source = love.image.newImageData(self.texturePacks:find(config.folder, config.file))
    local factor = math.max(1, math.floor(config.size / source:getWidth()))
    local icon = love.image.newImageData(source:getWidth() * factor, source:getHeight() * factor)

    icon:mapPixel(function(x, y)
        return source:getPixel(math.floor(x / factor), math.floor(y / factor))
    end)
    love.window.setIcon(icon)
end

return Window
