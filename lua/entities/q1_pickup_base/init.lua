AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.RespawnSound = Sound("items/q1/itembk2.wav")
ENT.RespawnSoundHQ = Sound("items/q1_hq/itembk2.wav")
ENT.PickupSound = Sound("weapons/q1/pkup.wav")
ENT.PickupSoundHQ = Sound("weapons/q1_hq/pkup.wav")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 40
	self.Spawn_angles = ply:GetAngles()
	self.Spawn_angles.pitch = 0
	self.Spawn_angles.roll = 0
	self.Spawn_angles.yaw = self.Spawn_angles.yaw
	local ent = ents.Create(self.ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(self.Spawn_angles)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel(self.model)
	self:SetModelScale(1.4, 0) 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self.Available = true
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, 24)
end

function ENT:PlaySound(snd, lvl, pitch, sndhq, ent)
	ent = ent or self
	if sndhq and q1_cvar_hqsnds:GetBool() then
		snd = sndhq
	end	
	ent:EmitSound(snd, lvl, pitch)
end

function ENT:Think()
	if self.ReEnabled and CurTime() >= self.ReEnabled then
		self.ReEnabled = nil
		self.Available = true
		self:SetNoDraw(false)
		self:PlaySound(self.RespawnSound, nil, nil, self.RespawnSoundHQ)
	end
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then
		local ammoCount = ent:GetAmmoCount(self.AmmoType)
		self.Available = false
		self:SetNoDraw(true)
		if game.SinglePlayer() then
			self:Remove()
		else
			self.ReEnabled = CurTime() + 30
		end
		self:PlaySound(self.PickupSound, 85, math.random(95,105), self.PickupSoundHQ, ent)
		ent:Give(self.WeapName)
		if ammoCount < self.MaxAmmo then
			ent:SetAmmo(math.min(ammoCount + self.AmmoAmount, self.MaxAmmo), self.AmmoType)
		end
	end
end