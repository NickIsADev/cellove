local BulkTrash = require("content/cells/destroyers/BulkTrash")

local BulkPhantom = setmetatable({
    name = "bulkphantom",
    k3 = 734,
    title = "Bulk Phantom",
    description = "A Bulk Trash that cannot be generated.",
    phantom = true
}, { __index = BulkTrash })
BulkPhantom.__index = BulkPhantom

return BulkPhantom
