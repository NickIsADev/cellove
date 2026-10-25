local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.ui.lift

local Lift = {}

function Lift.new(x, y)
    return { x = x, y = y, tilt = 0, raise = 0 }
end

function Lift.follow(state, x, y, dt)
    local tilt = utils.clamp((x - state.x) * config.follow * config.tilt.gain, -config.tilt.max, config.tilt.max)
    local ease = math.min(1, config.follow * dt)

    state.x, state.y = utils.lerp(state.x, x, ease), utils.lerp(state.y, y, ease)
    state.tilt = utils.lerp(state.tilt, tilt, math.min(1, config.tilt.ease * dt))
    state.raise = utils.lerp(state.raise, 1, math.min(1, config.raise * dt))
end

function Lift.release(state)
    return { x = state.x, y = state.y, tilt = state.tilt, raise = state.raise, time = 0 }
end

function Lift.land(landing, dt)
    landing.time = landing.time + dt
    return landing.time < config.settle
end

function Lift.at(landing, x, y)
    local progress = 1 - (1 - landing.time / config.settle) ^ 3

    return {
        x = utils.lerp(landing.x, x, progress),
        y = utils.lerp(landing.y, y, progress),
        tilt = utils.lerp(landing.tilt, 0, progress),
        raise = utils.lerp(landing.raise, 0, progress)
    }
end

function Lift.draw(state, width, height, shadow, content)
    local scale = 1 + (config.scale - 1) * state.raise

    love.graphics.push()
    love.graphics.translate(state.x + width / 2, state.y + height / 2)
    love.graphics.rotate(state.tilt)
    love.graphics.scale(scale)
    love.graphics.translate(-width / 2, -height / 2)

    shadow(config.shadow.offset * state.raise, config.shadow.alpha * state.raise)
    content()

    love.graphics.pop()
end

return Lift
