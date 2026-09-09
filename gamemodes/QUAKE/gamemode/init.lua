AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("hud.lua")

include("shared.lua")

function GM:PlayerSpawn(ply)
    -- self.BaseClass.PlayerSpawn( self, ply )

    if GetGlobalInt("meru_active") == 1 then
        ply:SetModel("models/alvaroports/samzan/merusuccubuspm.mdl")
    else
        ply:SetModel("models/akuld/qeranger/qeranger.mdl")
    end
    
    ply:SetupHands()

    -- if game.GetMap() != "q1_training" then
    --     ply:Give("weapon_q1_axe")
    --     ply:Give("weapon_q1_shotgun")
    -- end
end

concommand.Add("q1_meru_mode", function(ply, cmd, args)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local mode = tonumber(args[1]) or 0
    SetGlobalInt("meru_active", mode)
    if mode == 1 then
        if file.Exists("models/alvaroports/samzan/merusuccubuspm.mdl", "GAME") == false then
            ply:ChatPrint("Meru is not installed! Returning to Steph...")
            SetGlobalInt("meru_active", 0)
        else
            ply:SetModel("models/alvaroports/samzan/merusuccubuspm.mdl")
            ply:ChatPrint("Meru Mode Activated!")
        end
    else
        ply:ChatPrint("Meru Mode Deactivated!")
        ply:SetModel("models/akuld/qeranger/qeranger.mdl")
    end
end)

concommand.Add("q1_giveall", function(ply, cmd, args)
    local cheatsEnabled = GetConVar("sv_cheats"):GetInt()
    if cheatsEnabled == 0 then
        ply:ChatPrint("You must enable cheats to use this command.")
        return
    end
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if cheatsEnabled == 1 then
        ply:Give("weapon_q1_axe")
        ply:Give("weapon_q1_shotgun")
        ply:Give("weapon_q1_supershotgun")
        ply:Give("weapon_q1_nailgun")
        ply:Give("weapon_q1_supernailgun")
        ply:Give("weapon_q1_rocketlauncher")
        ply:Give("weapon_q1_grenadelauncher")
        ply:Give("weapon_q1_lightninggun")
        return
    end
end)