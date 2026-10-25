return {
    debug = {
        key = "f3",
        font = 12,
        interval = 0.1,
        margin = 12,
        top = 72,
        pad = 8,
        alpha = 0.85,
        colors = {
            warn = 0xFFD84D,
            buttons = { 0x6BDB6B, 0xFF4D4D, 0x4DA6FF }
        },
        frames = {
            count = 120,
            bar = 2,
            height = 40,
            gap = 6,
            limit = 1 / 20,
            warn = 1 / 55,
            bad = 1 / 30
        },
        cursor = { alpha = 0.25, offset = 12 },
        ripple = {
            time = 0.5,
            radius = 40,
            width = 2
        },
        drag = {
            width = 2,
            alpha = 0.7,
            dot = 4
        },
        log = {
            count = 6,
            life = 2,
            gap = 2
        },
        input = {
            right = 16,
            bottom = 72,
            gap = 12,
            key = {
                size = 28,
                gap = 4,
                pad = 8
            },
            mouse = {
                width = 40,
                height = 56,
                split = 24,
                wheel = 10,
                flash = 0.25
            }
        },
        world = {
            font = 10,
            zoom = {
                grid = 0.4,
                arrows = 0.6,
                labels = 1.5
            },
            alpha = {
                grid = 0.08,
                bounds = 0.9,
                hover = 0.2,
                label = 0.5
            },
            arrow = 0.35,
            tip = 3,
            cross = 12,
            width = 2,
            path = 0xFF9A3D
        },
        keys = {
            {
                { label = "Esc", keys = { "escape" } },
                { label = "`", keys = { "`" } },
                { label = "1", keys = { "1" } },
                { label = "2", keys = { "2" } },
                { label = "3", keys = { "3" } },
                { label = "Tab", keys = { "tab" } }
            },
            {
                { label = "Q", keys = { "q" } },
                { label = "W", keys = { "w" } },
                { label = "E", keys = { "e" } },
                { label = "R", keys = { "r" } }
            },
            {
                { label = "A", keys = { "a" } },
                { label = "S", keys = { "s" } },
                { label = "D", keys = { "d" } },
                { label = "F", keys = { "f" } }
            },
            {
                { label = "Z", keys = { "z" } },
                { label = "X", keys = { "x" } },
                { label = "C", keys = { "c" } },
                { label = "V", keys = { "v" } }
            },
            {
                { label = "Shift", keys = { "lshift", "rshift" } },
                { label = "Ctrl", keys = { "lctrl", "rctrl" } },
                { label = "Space", keys = { "space" } }
            }
        },
        text = {
            fps = "fps: %d  frame: %.1f ms  worst: %.1f ms",
            memory = "lua memory: %.2f MB",
            draw = "draw calls: %d (batched %d)  canvas switches: %d",
            gpu = "textures: %.2f MB  images: %d  canvases: %d  fonts: %d",
            window = "window: %dx%d px  ui: %dx%d  scale: %d%%",
            scene = "scene: %s  fade: %.2f",
            pending = "scene: %s -> %s  fade: %.2f",
            music = "music: %s (%d/%d)  %.0fs / %.0fs",
            sound = "sources: %d  music: %d%%  sfx: %d%%  speed: %d%%",
            none = "none",
            system = {
                game = "game: v%s (build %s)",
                love = "love: %d.%d.%d (%s)",
                lua = "lua: %s  arch: %s",
                os = "os: %s  cores: %d",
                gpu = "gpu: %s (%s)",
                api = "renderer: %s %s"
            },
            key = "key: %s",
            click = "mouse %d: %d, %d",
            wheel = "wheel: %+d",
            input = "text: %s",
            mouse = "%d, %d",
            game = {
                running = "running",
                paused = "paused",
                sim = "sim: %s  tick: %d  subtick: %d  pass: %d",
                speed = "interval: %.0f ms  progress: %d%%",
                grid = "grid: %dx%d  cells: %d  dying: %d  blasts: %d",
                tick = "last tick: sim %.1f ms  post %.1f ms  alloc %.2f MB  moved %d",
                render = "last redraw: collect %.1f ms  layer %.1f ms",
                camera = "camera: %.1f, %.1f  zoom: %.2f (%.2f)",
                tool = "tool: %s  cell: %s  rotation: %d  history: %d",
                markers = "markers: %d  contraption: %s",
                cursor = "cursor: %d, %d",
                cell = "cell: %s  rot: %d  turn: %d  path: %d  updated: %s"
            }
        }
    }
}
