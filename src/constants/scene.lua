local callbacks = {
    forwarded = { "keypressed", "textinput", "mousepressed", "mousemoved", "mousereleased", "wheelmoved", "filedropped", "focus", "quit" }
}
callbacks.pointer = {
    mousepressed = true,
    mousemoved = true,
    mousereleased = true
}
callbacks.all = { "update", "draw" }
for _, name in ipairs(callbacks.forwarded) do
    callbacks.all[#callbacks.all + 1] = name
end

return {
    scene = {
        callbacks = callbacks,
        fade = { time = 0.2, hold = 0.25 },
        loading = {
            text = "Loading...",
            size = 24,
            spinner = {
                texture = "rotator_cw",
                size = 48,
                speed = math.pi * 1.5
            }
        }
    }
}
