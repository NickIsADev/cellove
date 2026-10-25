local Scrollable = require("src/ui/abstract/Scrollable")
local constants = require("src/constants")

local config = constants.ui.list

local ScrollView = setmetatable({}, { __index = Scrollable })
ScrollView.__index = ScrollView

function ScrollView.new(data)
    local self = setmetatable({}, ScrollView)
    self:setup({ renderer = data.renderer, pad = config.pad, gap = data.gap })
    self.drawRow = data.drawRow
    return self
end

function ScrollView:_clip()
    return self.x, self.y, self.width, self.height
end

function ScrollView:place(x, y, width, height)
    local pad = self.pad
    Scrollable.place(self, x - pad, y - pad, width + pad * 2, height + pad * 2)
end

function ScrollView:heightOf(index)
    return self.items[index].height
end

function ScrollView:drawItem(...)
    self.drawRow(...)
end

function ScrollView:draw()
    self:drawItems()
end

return ScrollView
