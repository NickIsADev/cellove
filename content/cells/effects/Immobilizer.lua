local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local PushClamp = require("content/effects/PushClamp")
local PullClamp = require("content/effects/PullClamp")
local GrabClamp = require("content/effects/GrabClamp")
local SwapClamp = require("content/effects/SwapClamp")
local ScissorClamp = require("content/effects/ScissorClamp")
local TunnelClamp = require("content/effects/TunnelClamp")

local Immobilizer = setmetatable({
    name = "immobilizer",
    k3 = 310,
    title = "Immobilizer",
    description = "Applies every clamp to adjacent cells.",
    gives = { PushClamp, PullClamp, GrabClamp, SwapClamp, ScissorClamp, TunnelClamp }
}, { __index = BaseEffectGiver })
Immobilizer.__index = Immobilizer

return Immobilizer
