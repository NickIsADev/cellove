local BaseConverter = require("content/cells/abstract/BaseConverter")

local PartialConverter = setmetatable({
    name = "partialconverter",
    k3 = 1083,
    title = "Partial Converter",
    description = "Like a Converter, but it can take multiple cells to convert into one.",
    properties = {
        BaseConverter.properties[1],
        { id = "needed", title = "Needed", default = 2, min = 1, max = 99 }
    }
}, { __index = BaseConverter })
PartialConverter.__index = PartialConverter

function PartialConverter:new(data)
    local cell = BaseConverter.new(self, data)
    cell.count = 0
    return cell
end

function PartialConverter:absorb(cell)
    if self:held() and self.count < self.props.needed - 1 then
        self.count = self.count + 1
    else
        self.count = 0
        BaseConverter.absorb(self, cell)
    end
end

function PartialConverter:draw(renderer, ...)
    BaseConverter.draw(self, renderer, ...)
    renderer:drawTag(self.count .. "/" .. self.props.needed, ...)
end

return PartialConverter
