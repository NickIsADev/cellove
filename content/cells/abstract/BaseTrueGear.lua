local BaseGear = require("content/cells/abstract/BaseGear")

local BaseTrueGear = setmetatable({
    forced = true
}, { __index = BaseGear })
BaseTrueGear.__index = BaseTrueGear

function BaseTrueGear:pushable()
    return false
end

return BaseTrueGear
