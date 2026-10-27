local BaseCell = require("content/cells/abstract/BaseCell")

local Nudger = setmetatable({
    name = "nudger",
    k3 = 114,
    title = "Nudger",
    description = "Moves forward into empty space. Cannot push or pull.",
    categories = { "movers" },
    subtick = { 5 },
    drive = { push = true, pull = true },
    directional = true
}, { __index = BaseCell })
Nudger.__index = Nudger

function Nudger:update()
    self:nudge()
end

return Nudger
