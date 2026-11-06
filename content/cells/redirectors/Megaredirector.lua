local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local Megaredirector = setmetatable({
    name = "megaredirector",
    k3 = 741,
    title = "Megaredirector",
    description = "Redirector that also redirects diagonal neighbors.",
    faces = { 0 },
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseRedirector })
Megaredirector.__index = Megaredirector

return Megaredirector
