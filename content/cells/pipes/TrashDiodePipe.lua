local DiodePipe = require("content/cells/pipes/DiodePipe")

local TrashDiodePipe = setmetatable({
    name = "trashdiodepipe",
    title = "Trash Diode Pipe",
    description = "Diode Pipe that deletes any cell entering its front."
}, { __index = DiodePipe })
TrashDiodePipe.__index = TrashDiodePipe

function TrashDiodePipe:swappable(dx, dy)
    return not self:eats(-dx, -dy)
end

function TrashDiodePipe:eats(dx, dy)
    return (dx == 0 or dy == 0) and self:_entry(dx, dy) == 0 or DiodePipe.eats(self, dx, dy)
end

function TrashDiodePipe:absorb(cell, dx, dy)
    if self:_entry(dx, dy) ~= 0 then DiodePipe.absorb(self, cell, dx, dy) end
end

return TrashDiodePipe
