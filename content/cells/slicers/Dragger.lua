local Lifter = require("content/cells/slicers/Lifter")

local Dragger = setmetatable({
    name = "dragger",
    k3 = 274,
    title = "Dragger",
    description = "A Lifter that also pulls everything behind it.",
    categories = {
        "pullers",
        "grabbers",
        "slicers"
    },
    subtick = { "puller" },
    pulls = true
}, { __index = Lifter })
Dragger.__index = Dragger

return Dragger
