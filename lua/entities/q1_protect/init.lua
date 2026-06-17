AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/items/quake1/invulner.mdl"

local function PowerupActive(ply)
	return ply.QuakePowerups and ply.QuakePowerups.Pentagram
end

function ENT:Pickup(ent)
	if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration
	
	ent.QuakePowerups.Pentagram = duration
	if self.PDuration >= 3 then
		ent.QuakePowerups.PentagramOut = duration - 3
	end
	
	ent.OldArmor = ent:Armor()
	ent:SetArmor(666)
	
	self:PlaySound("items/q1/protect.wav", 500, 100, "items/q1_hq/protect.wav", ent)
	self:SendToClient(ent, ent.QuakePowerups)
	
	self:Remove()
end

hook.Add("PlayerPostThink", "QuakePowerups_Pentagram", function(ply)
	if !PowerupActive(ply) then return end
	
	if ply.QuakePowerups.PentagramOut and ply.QuakePowerups.PentagramOut <= CurTime() then
		ply.QuakePowerups.PentagramOut = nil
		local snd = "items/q1/protect2.wav"
		if q1_cvar_hqsnds:GetBool() then
			snd = "items/q1_hq/protect2.wav"
		end
		ply:EmitSound(snd, 90, 100)
	end	
	
	if ply.QuakePowerups.Pentagram <= CurTime() then
		ply.QuakePowerups.Pentagram = nil
		ply:SetArmor(ply.OldArmor)
	end
end)

hook.Add("PlayerShouldTakeDamage", "QuakePowerups_Pentagram", function(ply)
	if !PowerupActive(ply) then return end

	local snd = "items/q1/protect3.wav"
	if q1_cvar_hqsnds:GetBool() then
		snd = "items/q1_hq/protect3.wav"
	end
	ply:EmitSound(snd, 80, 100)
	return false
end)