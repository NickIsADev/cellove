local TetradivergerCW = require("content/cells/divergers/TetradivergerCW")

local TetradisplacerCW = setmetatable({
    name = "tetradisplacer_cw",
    k3 = 431,
    title = "Tetradisplacer (CW)",
    description = "Tetradiverger (CW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = TetradivergerCW })
TetradisplacerCW.__index = TetradisplacerCW

return TetradisplacerCW
