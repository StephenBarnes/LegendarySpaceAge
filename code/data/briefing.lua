-- This file adds a page to the tips-and-tricks page with some essential things to know.

data:extend {
    { -- Make category, to put it at the top.
        type = "tips-and-tricks-item-category",
        name = "Legendary-Space-Age",
        order = "---a",
    },
    {
        type = "tips-and-tricks-item",
        name = "legendary-space-age-briefing",
        indent = 0,
        order = "a",
        trigger = nil,
        skip_trigger = nil,
        simulation = nil,
        category = "Legendary-Space-Age",
    },
}