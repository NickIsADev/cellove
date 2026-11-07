local CellBrowser = require("src/ui/abstract/CellBrowser")

local CellPicker = setmetatable({}, { __index = CellBrowser })
CellPicker.__index = CellPicker

function CellPicker.new(renderer)
    local self = setmetatable({}, CellPicker)
    self:setup({ renderer = renderer })
    return self
end

function CellPicker:open(data)
    self.onPick, self.current = data.onPick, data.current
    CellBrowser.open(self, data.classes)
end

return CellPicker
