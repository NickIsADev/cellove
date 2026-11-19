local Pushable = require("content/cells/pushables/Pushable")

local Decoy = setmetatable({
    name = "decoy",
    k3 = 321,
    title = "Decoy",
    description = "Pushable that tricks Sentries, Turrets and Seekers into thinking it's a Player.",
    categories = { "players" },
    team = "friendly"
}, { __index = Pushable })
Decoy.__index = Decoy

return Decoy
