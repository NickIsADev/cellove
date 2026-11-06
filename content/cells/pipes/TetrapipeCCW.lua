local BasePipe = require("content/cells/abstract/BasePipe")
local TetradivergerCCW = require("content/cells/divergers/TetradivergerCCW")

local TetrapipeCCW = setmetatable({
    name = "tetrapipe_ccw",
    title = "Tetrapipe (CCW)",
    description = "Tetradiverger (CCW), but cells travel through it one step per tick.",
    faces = TetradivergerCCW.faces,
    routes = TetradivergerCCW.routes
}, { __index = BasePipe })
TetrapipeCCW.__index = TetrapipeCCW

return TetrapipeCCW
