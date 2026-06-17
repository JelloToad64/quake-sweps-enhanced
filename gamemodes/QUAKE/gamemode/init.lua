AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("hud.lua")

include("shared.lua")

function GM:PlayerSpawn(ply)
    self.BaseClass.PlayerSpawn( self, ply )
    ply:SetModel( "models/player/quakeguy.mdl" )
    ply:SetupHands()
    

    if game.GetMap() != "q1_training" then
        ply:Give("weapon_q1_axe")
        ply:Give("weapon_q1_shotgun")
    end
end