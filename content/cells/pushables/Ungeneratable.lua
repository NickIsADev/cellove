local Pushable = require("content/cells/pushables/Pushable")

local Ungeneratable = setmetatable({
    name = "ungeneratable",
    k3 = 20,
    title = "Ungeneratable",
    description = "A Pushable that cannot be generated. Generators only push when they try."
}, { __index = Pushable })
Ungeneratable.__index = Ungeneratable

function Ungeneratable:generated()
end

return Ungeneratable
