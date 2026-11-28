local BaseTurner = require("content/cells/abstract/BaseTurner")

local RedirectTurner = setmetatable({
    name = "redirectturner",
    k3 = 1047,
    title = "Redirect Turner",
    description = "Rotates any cell that pushes it to face the direction it faces.",
    categories = { "redirectors" },
    faces = { 0 }
}, { __index = BaseTurner })
RedirectTurner.__index = RedirectTurner

function RedirectTurner:_spin(cell, dx, dy)
    cell:rotate(self.rotation - cell.rotation, {
        quiet = true,
        dx = dx,
        dy = dy
    })
end

return RedirectTurner
