AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("hud.lua")

include("shared.lua")

function GM:PlayerSpawn(ply)
    self.BaseClass.PlayerSpawn( self, ply )

    if GetGlobalInt("meru_active") == 1 then
        ply:SetModel("models/alvaroports/samzan/merusuccubuspm.mdl")
    else
        ply:SetModel("models/akuld/qeranger/qeranger.mdl")
    end
    
    ply:SetupHands()

    if game.GetMap() != "q1_training" then
        ply:Give("weapon_q1_axe")
        ply:Give("weapon_q1_shotgun")
    end
end