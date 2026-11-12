local NudgerPlayer = require("content/cells/movers/NudgerPlayer")

local FragileNudgerPlayer = setmetatable({
    name = "fragilenudgeplayer",
    k3 = 296,
    title = "Fragile Nudger Player",
    description = "Like a Nudger Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = NudgerPlayer })
FragileNudgerPlayer.__index = FragileNudgerPlayer

return FragileNudgerPlayer
