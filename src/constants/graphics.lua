return {
    window = {
        icon = { folder = "ui", file = "icon.png", size = 256 }
    },

    renderer = {
        flat = 0.08,
        clear = { 0, 0, 0, 0 },
        box = {
            fill = 0.15,
            line = 0.9,
            width = 2
        },
        marker = {
            font = 20,
            shadow = { offset = 2, alpha = 0.6 },
            box = { width = 3, alpha = 0.9 }
        },
        tag = {
            font = 10,
            margin = 3,
            shadow = { offset = 5, alpha = 0.9 }
        },
        stored = {
            storage = 0.5,
            memory = 0.5,
            maker = 0.5
        },
        explosion = {
            pop = 0.1,
            grow = 0.5,
            time = 0.7,
            count = 16,
            distance = 3,
            size = 10,
            colors = { 0xFF2E2E, 0xFF4D4D, 0xFF6A3D, 0xFF9A3D }
        },
        shadow = {
            offset = 6,
            alpha = 0.5,
            shader = [[
vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen)
{
    return vec4(color.rgb, color.a * Texel(tex, uv).a);
}
]]
        }
    },

    background = {
        speed = 20,
        alpha = 0.35,
        scale = 2,
        logo = {
            textures = { "cellove" },
            chance = 0.05,
            seed = 10000,
            hash = {
                column = 12.9898,
                row = 78.233,
                scale = 43758.5453
            }
        }
    }
}
