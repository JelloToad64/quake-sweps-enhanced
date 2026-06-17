AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/items/quake1/suit.mdl"

local function PowerupActive(ply)
	return ply.QuakePowerups and ply.QuakePowerups.Biosuit
end

function ENT:Pickup(ent)
	if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration
	
	ent.QuakePowerups.Biosuit = duration
	if self.PDuration >= 3 then
		ent.QuakePowerups.BiosuitOut = duration - 3
	end
	
	self:PlaySound("items/q1/suit.wav", 500, 100, "items/q1_hq/suit.wav", ent)
	self:SendToClient(ent, ent.QuakePowerups)
	
	self:Remove()
end

hook.Add("PlayerPostThink", "QuakePowerups_Biosuit", function(ply)
	if !PowerupActive(ply) then return end
	
	if ply.QuakePowerups.BiosuitOut and ply.QuakePowerups.BiosuitOut <= CurTime() then
		ply.QuakePowerups.BiosuitOut = nil
		local snd = "items/q1/suit2.wav"
		if q1_cvar_hqsnds:GetBool() then
			snd = "items/q1_hq/suit2.wav"
		end
		ply:EmitSound(snd, 90, 100)
	end	
	
	if ply.QuakePowerups.Biosuit <= CurTime() then
		ply.QuakePowerups.Biosuit = nil
	end
end)

hook.Add("EntityTakeDamage", "QuakePowerups_Biosuit", function(ent, dmginfo)
	if ent:IsPlayer() and PowerupActive(ent) and (dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_ACID) or dmginfo:IsDamageType(DMG_RADIATION) or dmginfo:IsDamageType(DMG_NERVEGAS) or dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_SLOWBURN) or dmginfo:IsDamageType(DMG_DROWN) or dmginfo:IsDamageType(DMG_PARALYZE)) then
		return true
	end
end)