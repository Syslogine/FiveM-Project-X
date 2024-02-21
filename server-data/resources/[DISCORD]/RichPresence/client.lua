-- Initial setup for Discord Rich Presence
local function setupDiscordPresence()
    SetDiscordAppId(934650808505606214)
    SetDiscordRichPresenceAsset('fivem')
    SetDiscordRichPresenceAssetText('Explore Pixxy: A World of Endless Roleplay Possibilities')
    SetDiscordRichPresenceAssetSmall('fivem1')
    SetDiscordRichPresenceAssetSmallText('Pixxy: Forge Your Legend')
    SetDiscordRichPresenceAction(0, "Join Pixxy's Discord", "https://discord.gg/ekusEB65f8")
    SetDiscordRichPresenceAction(1, "Play Now on Pixxy", "fivem://connect/yarpii-zlyaz5.users.cfx.re/")
end

-- Call the setup function on resource start
setupDiscordPresence()

-- Example function to update Rich Presence based on player's activity
local function updatePresenceBasedOnActivity(activity)
    if activity == "driving" then
        SetDiscordRichPresenceAssetText('Cruising down the streets of Pixxy')
    elseif activity == "walking" then
        SetDiscordRichPresenceAssetText('Exploring the world on foot')
    end
end

-- Placeholder: Trigger updates based on in-game events
-- You'll need to hook into game events or create checks within game loops to detect player activities
-- For example, checking if the player is in a vehicle to set the activity to "driving"

-- Register events or use game loops as necessary to update the Rich Presence
-- This is a basic example using a loop to check player's activity every minute
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute (adjust as necessary for your use case)
        
        -- Example checks for activity (to be replaced with actual game state checks)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            updatePresenceBasedOnActivity("driving")
        else
            updatePresenceBasedOnActivity("walking")
        end
    end
end)
