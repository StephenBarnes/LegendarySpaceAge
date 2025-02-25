-- This file adds sections to the tips-and-tricks panel.

extend {
    { -- Make category, to put it at the top.
        type = "tips-and-tricks-item-category",
        name = "Legendary-Space-Age",
        order = "---a",
    },
}

---@type data.SimulationDefinition
local solarSimulation = {
    init_update_count = 100,
    checkboard = true,
    init = [[
        game.simulation.camera_zoom = 0.65
        game.simulation.camera_position = {3, 0}

        for x = -35, 35 do
            for y = -25, 25 do
                game.surfaces[1].set_tiles{{position = {x, y}, name = "lab-dark-1"}}
            end
        end

        for x = -13, -6 do
            for y = -1, 2, 3 do
                game.surfaces[1].set_tiles{{position = {x, y}, name = "lab-white"}}
            end
        end

        game.surfaces[1].create_entities_from_blueprint_string {
            string = "0eNqV2duK2lAARuF32ddxyGnn4KsMQ9F2MwQ0ijqlg+TdqzMwLdTVZN2pmE8i6xeN17DdvaXjaRgvYX0Nw/fDeA7r52s4D6/jZnd/bNzsU1iH82G3Oa2OmzHtwpSFYfyRfoV1Mb1kIY2X4TKkzwM/7rx/G9/223S6PSF7BGTheDjfjjmM91e4Oav6KWbh/XajiE9xmrJ/oHIhVMxB1TJo1qmXObMnFpc57ZzTLDyvfA5qF0LVHNQthJo5qF8I9XNQkS+TynJW8mGXIPmySdJpE6TbJkjHTZCvmySfN0m+b5J84CCVPnCSdOA9QLpvgmze5Ni6ybFxk6PbJkinTZAumyAdNkCV7pognXUDkM6aIJs1OTZrcmzW5OisCdJZE6SzJkhnDVCtsybor6wvabNfpfF1GNODHMuvt7sCqrQLIaiyCyGolgshJ8qFkNPIhZDT2oUQ1NmFENTbhQAUc7sQggq7EIJ01jlAOmuCbNbk2KzJsVmTo7MmSGdNkM4aoEZnTZDOmqBSf/AXIFVyIPDDoanlPsiJbh7ENG4dxLRuHMR0chvk9HIa4LS5XAY5hRwGOaXcBTl/Yt4eht3tof8M4rFQyznQ1bQo50BO4+ZATOvmQEzn5kBML+dAVxpzOQdyCjkHcko5B3IqOQdybMwdODZmcmTMxMiYiZExE2NjBqe3MZNjYybHxkyOjZkcG3MB33h6WzNCMmd0ZM/oyKDRsUUTVOS2aZZs1SzZrlmyZX9KL1kYLml//47y9SdsFn6m0/njkNiUfd33MbZFzNtumn4DLbR4ww==",
            position = {4, -1}
        }
        local boiler = game.surfaces[1].find_entities_filtered{name = "boiler"}[1]
        boiler.insert("solid-fuel")
        script.on_nth_tick(100, function()
            boiler.insert("solid-fuel")
            boiler.insert_fluid({name = "water", amount = 1000})
        end)
    ]]
}

for i, section in pairs{
    {name = "main", indent = 0},
    {name = "early-bots"},
    {name = "factors"},
    {name = "enemy-spawns"},
    {name = "enemy-resistances"},
    {name = "power-overload"},
    {name = "dumping"},
    {name = "fuels"},
    {name = "fluid-wagons"},
    {name = "advanced-logistics"},
    {
        name = "solar-power",
        simulation = solarSimulation,
        trigger = {type = "unlock-recipe", recipe = "solar-panel"},
    },
    {name = "space-platforms"},
    {name = "planet-drops"},
    {name = "vulcanus"},
    {name = "vulcanus-lava", indent = 2},
    {name = "gleba"},
    {name = "aquilo-trip"},
} do
    ---@type data.TipsAndTricksItem
    section = section
    section.name = "LSA-" .. section.name
    section.type = "tips-and-tricks-item"
    section.category = "Legendary-Space-Age"
    section.order = string.format("%02d", i)
    section.indent = section.indent or 1
    extend{section}
end
