local BaseSpinner = require("content/cells/abstract/BaseSpinner")

local RedirectSpinner = setmetatable({
    name = "redirectspinner",
    k3 = 1046,
    title = "Redirect Spinner",
    description = "Cannot be pushed, rotated, or destroyed. Rotates any cell that tries to push it to face the same direction.",
    categories = { "walls", "redirectors" }
}, { __index = BaseSpinner })
RedirectSpinner.__index = RedirectSpinner

function RedirectSpinner:_spin(cell, dx, dy)
    cell:rotate(self.rotation - cell.rotation, { dx = dx, dy = dy })
end

return RedirectSpinner
