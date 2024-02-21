-- This code sets up the Discord Rich Presence for your server.
-- It's executed once when the resource is started.

-- Set the Discord Application ID for your server's Rich Presence.
SetDiscordAppId(934650808505606214)

-- Set the main image for your server's Rich Presence.
SetDiscordRichPresenceAsset('fivem')

-- Set the hover text for the main image.
SetDiscordRichPresenceAssetText('Explore Pixxy: A World of Endless Roleplay Possibilities')

-- Set a small image for your server's Rich Presence.
SetDiscordRichPresenceAssetSmall('fivem1')

-- Set the hover text for the small image.
SetDiscordRichPresenceAssetSmallText('Pixxy: Forge Your Legend')

-- Define actions that can be taken from the Discord Rich Presence.
-- First action: Joining your Discord server.
SetDiscordRichPresenceAction(0, "Join Pixxy's Discord", "https://discord.gg/ekusEB65f8")

-- Second action: Directly connecting to your server.
SetDiscordRichPresenceAction(1, "Play Now on Pixxy", "fivem://connect/yarpii-zlyaz5.users.cfx.re/")
