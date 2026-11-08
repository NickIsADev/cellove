local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")

local Arrow = setmetatable({
    name = "arrow",
    title = "Arrow",
    description = "Can only be pushed from behind. Cannot be rotated by other cells.",
    anchored = true
}, { __index = SliderOneDirectional })
Arrow.__index = Arrow

return Arrow
