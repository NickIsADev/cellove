local BaseAcid = require("content/cells/abstract/BaseAcid")

local Acid = setmetatable({
    name = "acid",
    k3 = 220,
    title = "Acid",
    description = "Acts like an Enemy, but it can only destroy a cell when it gets pushed into one. Acids cannot destroy each other."
}, { __index = BaseAcid })
Acid.__index = Acid

return Acid
