-- Variables to store game state
local eventIndex = 0
local playerKills = {}  -- Table to keep track of player kills
local events = {
    "Zombie spawn in your back",
    "Shotgun everyone",
    "Give everyone S.L.A.M",
    "Spawn 1 Combine",
    "RPG to a random player",
    "Physgun to a random player",
    "Watermelon Rain",
    "Play a sound",
    "Get bunch Headcrabs"
}

-- Function to send messages to all players in chat
function SendMessageToAllPlayers(message)
    for _, ply in ipairs(player.GetAll()) do
        ply:ChatPrint(message)
    end
end

-- Function to execute a random event
function TriggerRandomEvent()
    eventIndex = eventIndex + 1
    local eventType = math.random(1, #events)  -- Select a random event
    local eventMessage = events[eventType]

    -- Send message about the event
    SendMessageToAllPlayers("Event #" .. eventIndex .. ": " .. eventMessage)

    -- Execute the event
    if eventType == 1 then
        -- Spawn zombies behind each player
        for _, ply in ipairs(player.GetAll()) do
            local zombie = ents.Create("npc_zombie")
            if IsValid(zombie) then
                zombie:SetPos(ply:GetPos() + ply:GetForward() * -100) -- Spawn behind the player
                zombie:Spawn()
            end
        end
    elseif eventType == 2 then
        -- Give shotgun to all players and ammo
        for _, ply in ipairs(player.GetAll()) do
            ply:Give("weapon_shotgun")
            ply:GiveAmmo(12, "Buckshot", true)  -- Give shotgun ammo
        end
    elseif eventType == 3 then
        -- Give S.L.A.M to all players and ammo
        for _, ply in ipairs(player.GetAll()) do
            ply:Give("weapon_slam")
            ply:GiveAmmo(3, "slam", true)  -- Give S.L.A.M. ammo
        end
    elseif eventType == 4 then
        -- Spawn 1 elite Combine
        for _, ply in ipairs(player.GetAll()) do
            local elite = ents.Create("npc_combine_s")
            if IsValid(elite) then
                elite:SetPos(ply:GetPos() + ply:GetForward() * -100)
                elite:SetKeyValue("numgrenades", "1") -- Set grenades if needed
                elite:Spawn()
            end
        end
    elseif eventType == 5 then
        -- Give RPG to a random player and ammo
        local players = player.GetAll()
        if #players > 0 then
            local randomPlayer = players[math.random(1, #players)]
            randomPlayer:Give("weapon_rpg")
            randomPlayer:GiveAmmo(1, "RPG_Round", true)  -- Give RPG ammo
        end
    elseif eventType == 6 then
        -- Give Physgun to a random player
        local players = player.GetAll()
        if #players > 0 then
            local randomPlayer = players[math.random(1, #players)]
            randomPlayer:Give("weapon_physgun")
        end
    elseif eventType == 7 then
        -- Watermelon rain
        for _, ply in ipairs(player.GetAll()) do
            for i = 1, 3 do
                local watermelon = ents.Create("prop_physics")
                if IsValid(watermelon) then
                    watermelon:SetModel("models/props_junk/watermelon01.mdl") -- Replace with watermelon model
                    watermelon:SetPos(ply:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 100)) -- Falling above the player
                    watermelon:Spawn()
                    watermelon:GetPhysicsObject():SetVelocity(Vector(0, 0, -500)) -- Falling down
                end
            end
        end
    elseif eventType == 8 then
        for _, ply in ipairs(player.GetAll()) do
            ply:EmitSound("ambient/alarms/alarm_citizen_loop1.wav")
        
            -- Остановить звук через 5 секунд
            timer.Simple( 5, function()
                if IsValid(ply) then
                    ply:StopSound("ambient/alarms/alarm_citizen_loop1.wav")
                end
            end)
        end
    elseif eventType == 9 then
        -- Spawn 5 headcrabs near each player
        for _, ply in ipairs(player.GetAll()) do
            for i = 1, 5 do
                local headcrab = ents.Create("npc_headcrab")
                if IsValid(headcrab) then
                    headcrab:SetPos(ply:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0)) -- Spawn around the player
                    headcrab:Spawn()
                end
            end
        end
    end

    -- Reset timer
    timer.Simple(10, function()
        TriggerRandomEvent()  -- Start the next event
    end)
end

-- Export the TriggerRandomEvent function for use in other files
return {
    TriggerRandomEvent = TriggerRandomEvent,
    SendMessageToAllPlayers = SendMessageToAllPlayers
}