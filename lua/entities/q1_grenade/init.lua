AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/projectiles/quake1/grenade.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:AddAngleVelocity(Vector(300,300,300))
	end
end

function ENT:SetExplodeDelay(flDelay)
	self.delayExplode = CurTime() + flDelay
end

function ENT:SetDamage(dmg, rad)
	self.Damage = dmg
	self.Radius = rad
end

function ENT:PhysicsCollide(data, phys)
	if !(data.HitEntity:IsPlayer() or data.HitEntity:IsNPC()) then
		local snd = "weapons/q1/bounce.wav"
		if q1_cvar_hqsnds:GetBool() then
			snd = "weapons/q1_hq/bounce.wav"
		end
		self:EmitSound(snd)
	end
	
	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end

function ENT:Think()
	if !self.delayExplode || CurTime() < self.delayExplode then return end
	self.delayExplode = nil
	self:Explode()
end

function ENT:Explode(pos)
	pos = pos or self:GetPos()
	util.BlastDamage(self, self:GetOwner(), pos, self.Radius, self.Damage)
	local snd = "weapons/q1/r_exp3.wav"
	if q1_cvar_hqsnds:GetBool() then
		snd = "weapons/q1_hq/r_exp3.wav"
	end
	
	local spos = self:GetPos()
	
	local effectdata = EffectData()
	effectdata:SetOrigin(spos)
	effectdata:SetNormal(Vector(0,0,1))
	util.Effect("q1_exp", effectdata, true, true)
	
	self:EmitSound(snd, 100, 100)
	self:Remove()	
	
	local tr = util.TraceLine({
		start = spos + Vector(0,0,64),
		endpos = spos + Vector(0,0,-32),
		filter = self
	})
	util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)      
end

function ENT:StartTouch(ent)
	if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then
 		self:Explode(ent:GetPos())
	end
end