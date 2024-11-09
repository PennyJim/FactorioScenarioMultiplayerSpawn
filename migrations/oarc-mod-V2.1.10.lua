--Migrate the force_grass to force_tiles new setting!
if storage.ocfg.spawn_general.force_tiles == nil then
    storage.ocfg.spawn_general.force_tiles = true
    log("Updating spawn_general config with new 'force_tiles' setting.")
end

-- Init OCFG surfaces for other planets if they don't exist.
if (storage.ocfg.surfaces_config["fulgora"] == nil) or 
    (storage.ocfg.surfaces_config["fulgora"].spawn_config.fill_tile == nil) then
    storage.ocfg.surfaces_config["fulgora"] =
    {
        spawn_config = FULGORA_SPAWN_CONFIG,
        starting_items = FULGORA_STARTER_ITEMS
    }
end

-- Refresh the Nauvis config if it is missing the new settings:
if storage.ocfg.surfaces_config["nauvis"].spawn_config.fill_tile == nil then
    storage.ocfg.surfaces_config["nauvis"] = {
        spawn_config = NAUVIS_SPAWN_CONFIG,
        starting_items = NAUVIS_STARTER_ITEMS
    }
end

--Make sure new planets get init'd. No harm in running this multiple times.
SeparateSpawnsInitPlanets()

-- Block spam. Highhly requested.
game.technology_notifications_enabled = false

-- New global teleport queue for nil characters.
if storage.nil_character_teleport_queue == nil then
    storage.nil_character_teleport_queue = {}
end