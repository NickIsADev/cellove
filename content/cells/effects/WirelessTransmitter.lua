local BaseTransmitter = require("content/cells/abstract/BaseTransmitter")

local WirelessTransmitter = setmetatable({
    name = "wirelesstransmitter",
    k3 = 583,
    title = "Wireless Transmitter",
    description = "Transmits to all other Wireless Transmitters with the same ID.",
    categories = { "otherrotators", "effects" },
    properties = {
        { id = "channel", title = "ID", default = 0, min = 0, max = 99 }
    }
}, { __index = BaseTransmitter })
WirelessTransmitter.__index = WirelessTransmitter

function WirelessTransmitter:_linked(cell)
    return getmetatable(cell) == WirelessTransmitter and cell.props.channel == self.props.channel
end

function WirelessTransmitter:_targets(wide)
    local targets, grid = BaseTransmitter._targets(self, wide), self.grid

    for index = 1, grid.width * grid.height do
        local cell = grid.cells[index]
        if cell and cell ~= self and self:_linked(cell) then targets[#targets + 1] = cell end
    end
    return targets
end

function WirelessTransmitter:draw(renderer, ...)
    BaseTransmitter.draw(self, renderer, ...)
    renderer:drawTag(self.props.channel, ...)
end

return WirelessTransmitter
