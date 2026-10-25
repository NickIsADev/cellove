local Widget = require("src/ui/abstract/Widget")
local Panel = require("src/ui/Panel")
local constants = require("src/constants")

local config = constants.ui.separator
local colors = constants.ui.colors

local Separator = setmetatable({}, { __index = Widget })
Separator.__index = Separator

function Separator.new(data)
    local self = setmetatable({}, Separator)
    self:setup({
        renderer = data.renderer,
        width = config.width,
        height = data.height
    })
    self.id = data.id
    self.enabled = false
    return self
end

function Separator:draw()
    Panel.fill(self.x, self.y, self.width, self.height, colors.white, config.alpha)
end

return Separator
