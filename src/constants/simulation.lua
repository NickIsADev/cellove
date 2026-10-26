return {
    directions = {
        [0] = {1, 0},  -- right
        [1] = {0, 1},  -- down
        [2] = {-1, 0}, -- left
        [3] = {0, -1}  -- up
    },

    simulator = {
        passes = { 0, 2, 3, 1 },
        scan = 3,
        hops = 100,
        subticks = 4,
        interval = 0.2
    },

    grid = {
        default = { width = 25, height = 25 },
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
            ease = 15
        }
    }
}
