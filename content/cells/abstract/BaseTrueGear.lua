local BaseGear = require("content/cells/abstract/BaseGear")

local BaseTrueGear = setmetatable({
    subtick = { "trueGear" },
    sweep = { x = 1, y = 1 },
    forced = true,
    fixed = true,
    anchored = true
}, { __index = BaseGear })
BaseTrueGear.__index = BaseTrueGear

return BaseTrueGear
