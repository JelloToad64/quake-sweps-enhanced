AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = Model("models/projectiles/quake1/spike.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(), Vector())
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
end

function ENT:Touch(ent)
	if !ent:IsSolid() then return end

	if self.didHit then return end
	self.didHit = true
	
	local tr = self:GetTouchTrace()

	ent:TakeDamage(self.Damage, self:GetOwner())
	if !(ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) then
		local sndRic = "weapons/q1/ric"..math.random(1,3)..".wav"
		local sndTink = "weapons/q1/tink1.wav"
		if q1_cvar_hqsnds:GetBool() then
			sndRic = "weapons/q1_hq/ric"..math.random(1,3)..".wav"
			sndTink = "weapons/q1_hq/tink1.wav"
		end
		
		local hitSnd = sndTink		
		if math.random(0, 4) == 0 then
			hitSnd = sndRic
		end
		sound.Play(hitSnd, tr.HitPos, 80, 100, 1, CHAN_ITEM)
	end
	
	self:ImpactEffect(tr)
	self:Remove()
end