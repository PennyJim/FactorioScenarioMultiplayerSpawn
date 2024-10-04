-- Contains the GUI for the player list tab.

---Used by AddOarcGuiTab
---@param tab_container LuaGuiElement
---@param player LuaPlayer
---@return nil
function CreatePlayerListTab(tab_container, player)

    local scroll_pane = tab_container.add {
        type = "scroll-pane",
        direction = "vertical",
        vertical_scroll_policy = "always",
    }


    -- Make a table: player name, force name, home surface, time played, gps button
    local player_table = scroll_pane.add {
        type = "table",
        column_count = 6,
        style = "bordered_table",
    }

    --- Add the header rows
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-player"}, "caption_label")
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-force"}, "caption_label")
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-surface"}, "caption_label")
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-time-player"}, "caption_label")
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-location"}, "caption_label")
    AddLabel(player_table, nil, {"oarc-player-list-tab-column-header-status"}, "caption_label")

    -- List online players first
    for _,online_player in pairs(game.connected_players) do
        AddPlayerRow(player_table, online_player.name, true)
    end

    -- List offline players later
    for  _,player in pairs(game.players) do
        if (not player.connected) then
            AddPlayerRow(player_table, player.name, false)
        end
    end

end


---Add a row to the table for a player
---@param table LuaGuiElement
---@param player_name string
---@param online boolean
---@return nil
function AddPlayerRow(table, player_name, online)
    local player = game.players[player_name]
    if (player) then
        AddLabel(table, nil, player.name, my_label_style)
        AddLabel(table, nil, player.force.name, my_label_style)

        -- Get the player's home surface
        local spawn = FindPlayerHomeSpawn(player.name)
        if (spawn) then
            AddLabel(table, nil, spawn.surface_name, my_label_style)
        else
            AddLabel(table, nil, "Unknown", my_label_style)
        end

        AddLabel(table, nil, FormatTimeHoursSecs(player.online_time), my_label_style)
        CreatePlayerGPSButton(table, player.name)
        
        if online then
            if (player.admin) then
                AddLabel(table, nil, {"oarc-player-online"}, my_player_list_admin_style)
            else
                AddLabel(table, nil, {"oarc-player-online"}, my_player_list_style)
            end
        else
            AddLabel(table, nil, {"oarc-player-offline"}, my_player_list_offline_style)
        end
    end
end


---Display a GPS button for a specific location. (For the player list)
---@param container LuaGuiElement
---@param player_name string
---@return nil
function CreatePlayerGPSButton(container, player_name)
    local gps_button = container.add {
        type = "sprite-button",
        sprite = "utility/gps_map_icon",
        tags = {
            action = "oarc_player_list_tab",
            setting = "show_location",
            player_name = player_name,
        },
        style = "slot_button",
        tooltip = { "oarc-player-list-tab-location-button-tooltip" },
    }
    gps_button.style.width = 28
    gps_button.style.height = 28
end

---Handle the gui click of the player list tab in the Oarc GUI.
---@param event EventData.on_gui_click
---@return nil
function PlayerListGuiClick(event)
    if not event.element.valid then return end
    local player = game.players[event.player_index]
    local tags = event.element.tags

    if (tags.action ~= "oarc_player_list_tab") then
        return
    end

    -- Shows the player's current location on the map
    if (tags.setting == "show_location") then
        local player_name = tags.player_name --[[@as string]]
        local target_player = game.players[player_name]
        
        player.open_map(target_player.position, 0.05) -- TODO: Update this for spage age!
    end
end