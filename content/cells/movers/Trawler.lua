local Grabber = require("content/cells/movers/Grabber")

local Trawler = setmetatable({
    name = "trawler",
    k3 = "bm trawler",
    title = "Trawler",
    description = "Moves forward into empty space, dragging the cells at its back diagonals along with it. Cannot push or pull.",
    categories = { "grabbers" },
    subtick = { "trawler" },
    skew = -1
}, { __index = Grabber })
Trawler.__index = Trawler

return Trawler
