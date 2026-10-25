local TetradivergerCCW = require("content/cells/divergers/TetradivergerCCW")

local TetradisplacerCCW = setmetatable({
    name = "tetradisplacer_ccw",
    k3 = 432,
    title = "Tetradisplacer (CCW)",
    description = "Tetradiverger (CCW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = TetradivergerCCW })
TetradisplacerCCW.__index = TetradisplacerCCW

return TetradisplacerCCW
