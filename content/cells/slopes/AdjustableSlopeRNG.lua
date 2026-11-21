local AdjustableSlope = require("content/cells/slopes/AdjustableSlope")

local AdjustableSlopeRNG = setmetatable({
    name = "adjustableslope_rng",
    k3 = 1094,
    title = "Adjustable Slope (RNG)",
    description = "Adjustable Slope that shifts cells in a random direction.",
    sense = "rng",
    faces = {}
}, { __index = AdjustableSlope })
AdjustableSlopeRNG.__index = AdjustableSlopeRNG

return AdjustableSlopeRNG
