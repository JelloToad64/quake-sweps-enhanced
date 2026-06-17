AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.RespawnSound = Sound("items/q1/itembk2.wav")
ENT.RespawnSoundHQ = Sound("items/q1_hq/itembk2.wav")

ENT.RespTime = 30

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(self.ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel(self.model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self.Available = true
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, 20)
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
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available and ent:Health() < self.MaxHealth then
		self.Available = false
		self:SetNoDraw(true)
		if game.SinglePlayer() then
			self:Remove()
		else
			self.ReEnabled = CurTime() + self.RespTime
		end
		self:PlaySound(self.Hsound, 85, math.random(99,101), self.HsoundHQ, ent)
		ent:SetHealth(math.min(ent:Health() + self.Hamount, self.MaxHealth))
	end
end