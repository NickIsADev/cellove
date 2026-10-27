local Pushable = require("content/cells/pushables/Pushable")

local Ungeneratable = setmetatable({
    name = "ungeneratable",
    k3 = 20,
    title = "Ungeneratable",
    description = "A pushable that cannot be generated. Generators only push when they try."
}, { __index = Pushable })
Ungeneratable.__index = Ungeneratable

function Ungeneratable:generatable()
    return false
end

return Ungeneratable
