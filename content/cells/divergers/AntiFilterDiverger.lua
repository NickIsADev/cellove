local FilterDiverger = require("content/cells/divergers/FilterDiverger")

local AntiFilterDiverger = setmetatable({
    name = "antifilterdiverger",
    k3 = 601,
    title = "Anti-Filter Diverger",
    description = "Lets cells pass straight through along its axis only if they are the same type as the one inserted into its side, and deletes the rest."
}, { __index = FilterDiverger })
AntiFilterDiverger.__index = AntiFilterDiverger

function AntiFilterDiverger:_blocks(mover)
    return not self:_matches(mover)
end

return AntiFilterDiverger
