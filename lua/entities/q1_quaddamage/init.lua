AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/items/quake1/quaddama.mdl"

local function PowerupActive(ply)
	return ply.QuakePowerups and ply.QuakePowerups.QuadDamage
end

function ENT:Pickup(ent)
	if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration
	
	ent.QuakePowerups.QuadDamage = duration
	if self.PDuration >= 3 then
		ent.QuakePowerups.QuadDamageOut = duration - 3
	end
	
	self:PlaySound("items/q1/damage.wav", 500, 100, "items/q1_hq/damage.wav", ent)
	self:SendToClient(ent, ent.QuakePowerups)
	
	self:Remove()
end

hook.Add("PlayerPostThink", "QuakePowerups_QuadDamage", function(ply)
	if !PowerupActive(ply) then return end
	
	if ply.QuakePowerups.QuadDamageOut and ply.QuakePowerups.QuadDamageOut <= CurTime() then
		ply.QuakePowerups.QuadDamageOut = nil
		local snd = "items/q1/damage2.wav"
		if q1_cvar_hqsnds:GetBool() then
			snd = "items/q1_hq/damage2.wav"
		end
		ply:EmitSound(snd, 90, 100)
	end	
	
	if ply.QuakePowerups.QuadDamage <= CurTime() then
		ply.QuakePowerups.QuadDamage = nil
	end
end)

hook.Add("EntityTakeDamage", "QuakePowerups_QuadDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and PowerupActive(attacker) then
		dmginfo:ScaleDamage(4)
	end
end)

hook.Add("EntityEmitSound", "QuakePowerups_QuadDamage", function(t)
	local ent = t.Entity
	if IsValid(ent) and ent:IsPlayer() then
		if PowerupActive(ent) and t.Channel == CHAN_WEAPON then
			local wep = ent:GetActiveWeapon()
			if IsValid(wep) and wep.Base != "weapon_q1_base" then
				if game.SinglePlayer() then
					wep:EmitSound("Weapon_Quake1Quad")
				else
					ent:EmitSound("Weapon_Quake1Quad")
				end
			end
		end
	end
end)