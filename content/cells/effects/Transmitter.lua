local BaseTransmitter = require("content/cells/abstract/BaseTransmitter")

local Transmitter = setmetatable({
    name = "transmitter",
    k3 = 105,
    title = "Transmitter",
    description = "When rotated, flipped, or given an effect such as protection, it applies the effects to it's neighbors aswell."
}, { __index = BaseTransmitter })
Transmitter.__index = Transmitter

return Transmitter
