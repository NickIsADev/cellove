local Driller = require("content/cells/drillers/Driller")

local Bringer = setmetatable({
    name = "bringer",
    k3 = 61,
    title = "Bringer",
    description = "A Driller that pulls everything behind it before drilling.",
    categories = { "pullers", "drillers" },
    pulls = true
}, { __index = Driller })
Bringer.__index = Bringer

function Bringer:update()
    if not self:pull() then self:drill() end
end

return Bringer
