local DiodeDiverger = require("content/cells/divergers/DiodeDiverger")

local TrashDiodeDiverger = setmetatable({
    name = "trashdiodediverger",
    k3 = 300,
    title = "Trash Diode Diverger",
    description = "Diode Diverger that deletes any cell entering its front."
}, { __index = DiodeDiverger })
TrashDiodeDiverger.__index = TrashDiodeDiverger

function TrashDiodeDiverger:eats(dx, dy)
    return self:_entry(dx, dy) == 0
end

return TrashDiodeDiverger
