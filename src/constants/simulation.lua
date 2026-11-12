return {
    directions = {
        [0] = {1, 0},  -- right
        [1] = {0, 1},  -- down
        [2] = {-1, 0}, -- left
        [3] = {0, -1}  -- up
    },

    ring = {
        { 1, 0 }, { 1, 1 }, { 0, 1 }, { -1, 1 }, { -1, 0 }, { -1, -1 }, { 0, -1 }, { 1, -1 }
    },

    flip = {
        reflections = {
            [0] = { 1, 0, 0, -1 },
            [1] = { 0, 1, 1, 0 },
            [2] = { -1, 0, 0, 1 },
            [3] = { 0, -1, -1, 0 }
        },
        shift = { straight = 2, diagonal = 1 }
    },

    simulator = {
        subticks = {
            "pipe",
            "trueGear",
            "dumpster",
            "midas",
            "superMirror",
            "mirror",
            "curvedMirror",
            "cyclerCW",
            "cyclerCCW",
            "memoryGenerator",
            "generator",
            "memoryReplicator",
            "maker",
            "superRotator",
            "rotator",
            "spin",
            "flipGear",
            "gearCW",
            "gearCCW",
            "gear180",
            "gearRNG",
            "superRedirector",
            "redirector",
            "inertia",
            "vacuum",
            "superImpulsor",
            "impulsor",
            "fan",
            "superRepulsor",
            "repulsor",
            "magnetX",
            "magnetY",
            "driller",
            "puller",
            "trawler",
            "grabber",
            "thruster",
            "mover",
            "nudger",
            "player",
            "fearful",
            "gate",
            "spread",
            "decay",
            "settlestorage"
        },
        passes = { 0, 2, 3, 1 },
        axes = {
            [0] = 0,   -- horizontal
            [2] = 1.5, -- diagonal
            [3] = 0.5, -- diagonal
            [1] = 1    -- vertical
        },
        corners = {
            [0] = 3.5,
            [2] = 1.5,
            [3] = 0.5,
            [1] = 2.5
        },
        scan = 3,
        controls = {
            { direction = 0, keys = { "d", "right" } },
            { direction = 2, keys = { "a", "left" } },
            { direction = 3, keys = { "w", "up" } },
            { direction = 1, keys = { "s", "down" } }
        },
        hops = 100,
        flushes = 5,
        interval = 0.2
    },

    grid = {
        default = { width = 25, height = 25 },
        border = "wall",
        limits = { min = 1, max = 500 },
        tile = 40
    },

    camera = {
        speed = 600,
        ease = 8,
        threshold = 4,
        zoom = {
            default = 1,
            step = 1.25,
            min = 0.02,
            max = 10,
            ease = 15,
            settle = 0.001
        }
    }
}
