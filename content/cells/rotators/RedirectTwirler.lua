local BaseTwirler = require("content/cells/abstract/BaseTwirler")

local RedirectTwirler = setmetatable({
    name = "redirecttwirler",
    k3 = 1132,
    title = "Redirect Twirler",
    description = "When pushed, rotates the cell it pushes into to face the direction it faces.",
    categories = { "redirectors" },
    faces = { 0 }
}, { __index = BaseTwirler })
RedirectTwirler.__index = RedirectTwirler

function RedirectTwirler:_spin(cell, dx, dy)
    cell:rotate(self.rotation - cell.rotation, {
        quiet = true,
        dx = dx,
        dy = dy
    })
end

return RedirectTwirler
