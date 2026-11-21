return {
    display = {
        base = { width = 1280, height = 720 },
        step = 0.5
    },

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
            shadow = { offset = 4, alpha = 0.6 },
            box = { width = 3, alpha = 0.9 }
        },
        tag = {
            font = 8,
            anchors = {
                corner = {
                    x = 0.5,
                    y = 0.5,
                    pivot = 1,
                    margin = 4
                },
                center = {
                    x = 0,
                    y = 0,
                    pivot = 0.5,
                    margin = 0,
                    align = "center"
                },
                count = {
                    x = -0.2,
                    y = -0.1375,
                    pivot = 0,
                    margin = 0
                }
            },
            shadow = { offset = 1, alpha = 1 }
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
        spark = {
            texture = "sparkle",
            folder = "particles",
            scale = 2,
            speed = 200,
            area = 10,
            life = { 0.5, 1 },
            kinds = {
                coin = { colors = { 1, 0.75, 0.25, 1, 0.5, 0.25, 0, 1 }, size = 1, count = 25 },
                sparkle = { colors = { 1, 0, 0.75, 1, 0.5, 0, 0.25, 1 }, size = 1, count = 50 },
                greysparkle = { colors = { 0.75, 0.75, 0.75, 1, 0.5, 0.5, 0.5, 1 }, size = 1, count = 25 },
                quantum = { colors = { 0.75, 0, 1, 1, 0.375, 0, 0.5, 1 }, size = 1, count = 50 }
            }
        },
        shadow = {
            distance = 0.15,
            alpha = 0.25,
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
