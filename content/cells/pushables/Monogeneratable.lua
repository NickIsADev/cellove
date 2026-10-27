local Pushable = require("content/cells/pushables/Pushable")
local Ungeneratable = require("content/cells/pushables/Ungeneratable")

local Monogeneratable = setmetatable({
    name = "monogeneratable",
    k3 = 643,
    title = "Monogeneratable",
    description = "A pushable that turns into an Ungeneratable when generated."
}, { __index = Pushable })
Monogeneratable.__index = Monogeneratable

function Monogeneratable:generated()
    return Ungeneratable
end

return Monogeneratable
