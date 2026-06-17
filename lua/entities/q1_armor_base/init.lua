AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.PickupSound = Sound("items/q1/armor1.wav")
ENT.PickupSoundHQ = Sound("items/q1_hq/armor1.wav")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 15
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

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available and ent:Armor() < self.MaxArmor then
		self.Available = false
		self:SetNoDraw(true)
		if game.SinglePlayer() then
			self:Remove()
		else
			self.ReEnabled = CurTime() + 30
		end
		self:PlaySound(self.PickupSound, 85, math.random(99,101), self.PickupSoundHQ, ent)
		ent:SetArmor(math.min(ent:Armor() + self.Aamount, self.MaxArmor))
	end
end