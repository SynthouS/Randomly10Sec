GM.Name = "Randomly 10 seconds"
GM.Author = "SynthouS"
GM.Website = ""
GM.Version = "HotDog"

include("sv_events.lua")

local gameTime = 0
local playerKills = {}

function GM:Initialize()
    -- Game initialization
    SendMessageToAllPlayers("Game start! Waiting for events...")
    
    timer.Create("GameTimeTimer", 1, 0, function()
        gameTime = gameTime + 1
    end)
end

function GM:PlayerSpawn(ply)
    ply:SetModel("models/player/Group 01/male_01.mdl")
end

-- Start events on the first spawn of a player
function GM:PlayerInitialSpawn(ply)
    if #player.GetAll() == 1 then  -- Check if this is the first player
        -- Start the timer
        timer.Simple(1, function()
            for i = 1, 10 do
                timer.Simple(i, function()
                    SendMessageToAllPlayers(tostring(i))
                end)
            end

            -- Start the first event
            TriggerRandomEvent()
        end)
    end
end

-- Function to handle player deaths and track kills
function GM:PlayerDeath(victim, inflictor, attacker)
    if IsValid(attacker) and attacker:IsPlayer() then
        playerKills[attacker] = (playerKills[attacker] or 0) + 1  -- Increment the kill count for the attacker
        if playerKills[attacker] >= 25 then
            SendMessageToAllPlayers(attacker:GetName() .. " Winner!")  -- Announce the winner
            
            -- Map Reload
            timer.Simple(10, function()
                RunConsoleCommand("changelevel", game.GetMap())
            end)
        end
    end
end

-- HUD
hook.Add("HUDPaint", "HUDPaint_DrawABox", function()
    local minutes = math.floor(gameTime / 60)
    local seconds = gameTime % 60
    local timeString = string.format("%02d:%02d", minutes, seconds)

    local boxWidth = 100
    local boxHeight = 50
    local x = (ScrW() - boxWidth) / 2
    local y = 10

    -- Draw the timer box
    surface.SetDrawColor(30, 30, 30, 200)
    surface.DrawRect(x, y, boxWidth, boxHeight)
    draw.SimpleText(timeString, "Trebuchet24", x + boxWidth / 2, y + boxHeight / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)