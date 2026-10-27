local BaseCell = require("content/cells/abstract/BaseCell")
local Pushable = require("content/cells/pushables/Pushable")
local Ungeneratable = require("content/cells/pushables/Ungeneratable")

local XGeneratable = setmetatable({
    name = "xgeneratable",
    k3 = 644,
    title = "X-Generatable",
    description = "A Monogeneratable with adjustable layers. Each generation removes one, then it turns into an Ungeneratable.",
    properties = {
        { id = "layers", title = "Layers", default = 2, min = 1, max = 99 }
    }
}, { __index = Pushable })
XGeneratable.__index = XGeneratable

function XGeneratable:generated()
    local remaining = self.props.layers - 1
    if remaining == 0 then return Ungeneratable end
    return getmetatable(self), { layers = remaining }
end

function XGeneratable:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.props.layers, ...)
end

return XGeneratable
