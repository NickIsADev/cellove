local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local SliderOpposition = setmetatable({
    name = "slideropposition",
    k3 = 54,
    title = "Slider Opposition",
    description = "Cannot be pushed from its front or pulled from behind, and can only be grabbed sideways.",
    faces = { 0 },
    moves = {
        push = {
            back = true,
            left = true,
            right = true
        },
        pull = {
            front = true,
            left = true,
            right = true
        },
        grab = { left = true, right = true }
    }
}, { __index = BaseOpposition })
SliderOpposition.__index = SliderOpposition

return SliderOpposition
