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
        },
        boot = {
            text = "Starting...",
            chunk = 20,
            font = "texturepacks/default/font/regular.ttf",
            spinner = "texturepacks/default/cells/rotator_cw.png",
            bar = { width = 240, height = 4, gap = 16 },
            stages = {
                settings = { text = "Loading settings...", from = 0, to = 0.05 },
                mods = { text = "Loading mods...", from = 0.05, to = 0.15 },
                scripts = { text = "Loading scripts...", from = 0.15, to = 0.35 },
                graphics = { text = "Setting up graphics...", from = 0.35, to = 0.45 },
                registry = { text = "Registering cells...", from = 0.45, to = 0.5 },
                textures = { text = "Loading textures...", from = 0.5, to = 0.9 },
                content = { text = "Loading content...", from = 0.9, to = 0.97 },
                scenes = { text = "Starting game...", from = 0.97, to = 1 }
            }
        }
    }
}
