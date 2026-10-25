local IconButton = require("src/ui/widgets/IconButton")
local constants = require("src/constants")

local config = constants.ui.back

local BackButton = {}

function BackButton.new(renderer)
    local button = IconButton.new({
        renderer = renderer,
        id = "back",
        folder = "cells",
        texture = "rotator_ccw",
        size = config.size,
        spin = -math.pi / 2,
        label = config.label,
        labelSide = "right",
        labelFont = config.font,
        labelGap = config.gap
    })
    button:place(config.margin, config.margin)
    return button
end

return BackButton
