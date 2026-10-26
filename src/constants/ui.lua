return {
    ui = {
        disabled = 0.35,
        hover = { speed = 30, growth = 0.15 },
        colors = {
            white = 0xFFFFFF,
            dark = 0x0C0C0C,
            panel = 0x242424,
            border = 0x737373,
            track = 0x4D4D4D,
            muted = 0x8C8C8C,
            accent = 0x6BDB6B,
            danger = 0xFF4D4D,
            warning = 0xFFB84D
        },
        panel = {
            alpha = 0.9,
            width = 2,
            highlight = 0.6,
            dash = 6,
            hole = { fill = 0.05, alpha = 0.5, speed = 24 },
            heading = { gap = 8, center = 0.56 }
        },
        shadow = { offset = 4, alpha = 0.6 },
        lift = {
            follow = 28,
            raise = 14,
            scale = 1.05,
            settle = 0.16,
            tilt = { gain = 0.00012, max = 0.1, ease = 14 },
            shadow = { offset = 10, alpha = 0.3 }
        },
        title = { y = 0.08 },
        back = {
            size = 40,
            margin = 24,
            gap = 16,
            font = 24,
            label = "Back"
        },
        button = { height = 40, font = 16 },
        label = { font = 16, shadow = { offset = 2, alpha = 0.6 } },
        separator = { width = 2, alpha = 0.3 },
        swatch = { size = 28 },
        shine = {
            speed = 0.6,
            width = 0.3,
            gap = 1,
            strength = 0.6,
            shader = [[
uniform float time;
uniform float width;
uniform float span;
uniform float strength;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen)
{
    vec4 base = Texel(tex, uv) * color;
    float band = max(0.0, 1.0 - abs((uv.x + uv.y) / 2.0 - (fract(time) * span - width)) / width);
    return vec4(base.rgb + band * strength * base.a, base.a);
}
]]
        },
        avatar = { font = 32, alpha = 0.4, cap = 0.75 },
        field = {
            height = 40,
            pad = 10,
            font = 16,
            blink = 0.5,
            label = 72,
            limit = 64,
            caret = 2,
            selection = 0.3
        },
        icon = {
            alpha = { idle = 0.8, hover = 1 },
            glow = 0.25,
            labelFont = 16,
            labelGap = 8
        },
        list = {
            pad = 8,
            target = 0.6,
            slide = 22,
            scroll = {
                step = 48,
                width = 6,
                gap = 8,
                min = 24
            },
            row = {
                inset = 4,
                hover = 0.06,
                selected = 0.1,
                outline = 0.8,
                separator = 0.08
            }
        },
        stepper = {
            height = 40,
            font = 16,
            label = 72,
            value = 52,
            gap = 6,
            track = 4,
            handle = { width = 8, height = 22 },
            delay = 0.4,
            rate = 0.04
        },
        toggle = {
            height = 40,
            font = 16,
            label = 72,
            size = 24,
            on = { texture = "checkmark", tint = "accent" },
            off = { texture = "x", tint = "white" }
        }
    },

    toast = {
        time = 2.5,
        fade = 0.4,
        enter = 0.2,
        slide = 14,
        font = 16,
        pad = 12,
        gap = 10,
        icon = 20,
        shadow = 4,
        top = 36
    },

    prompt = {
        width = 460,
        control = 348,
        margin = 16,
        pad = 20,
        gap = 14,
        font = { title = 24, text = 16 },
        button = {
            size = 40,
            gap = 56,
            font = 16,
            labelGap = 6
        },
        text = { confirm = "Confirm", cancel = "Cancel" },
        dim = 0.6
    },

    colorPicker = {
        title = "Pick a Color",
        square = 200,
        bar = 24,
        handle = 6,
        stops = 6
    },

    tooltip = {
        font = { title = 18, description = 8 },
        pad = 10,
        gap = 4,
        width = 300,
        offset = 4
    }
}
