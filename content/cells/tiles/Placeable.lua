local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local hues = constants.markers.hues

local Placeable = setmetatable({
    name = "placeable",
    title = "Placeable",
    description = "Marks a tile where cells can be moved in puzzles. Cells only move between tiles of the same color.",
    categories = { "puzzles" },
    tile = "placeable",
    properties = {
        { id = "color", title = "Color", default = 1, min = 1, max = #hues, swatches = hues }
    }
}, { __index = BaseCell })
Placeable.__index = Placeable

return Placeable
