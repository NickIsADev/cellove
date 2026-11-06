local BasePipe = require("content/cells/abstract/BasePipe")
local TetradivergerCW = require("content/cells/divergers/TetradivergerCW")

local TetrapipeCW = setmetatable({
    name = "tetrapipe_cw",
    title = "Tetrapipe (CW)",
    description = "Tetradiverger (CW), but cells travel through it one step per tick.",
    faces = TetradivergerCW.faces,
    routes = TetradivergerCW.routes
}, { __index = BasePipe })
TetrapipeCW.__index = TetrapipeCW

return TetrapipeCW
