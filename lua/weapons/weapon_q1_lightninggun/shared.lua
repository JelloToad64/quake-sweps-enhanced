if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Thunderbolt"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 7
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/light_icon")	
	killicon.Add("weapon_q1_lightninggun", "weapons/light_icon", Color(255, 80, 0, 255))
	
end

local cvar_maxdist = CreateConVar("q1_sv_thunderbolt_maxdist", 768, FCVAR_REPLICATED)

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(0) then return end	
	if self.Owner:IsNPC() then
		self:WeaponSound()
	end	
	if !self:GetAttack() then
		if !self.Owner:IsNPC() then
			if !self.firesound or (self.firesound and !self.firesound:IsPlaying()) then
				self.firesound = CreateSound(self.Owner, self.Primary.LoopSound)
				self.firesound:SetSoundLevel(90)
				self.firesound:Play()
			end
			self:WeaponSound()
		end
		self:SuperDamageSound()
	end
	self:SetAttack(true)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireLight()
	self:TakeAmmo(1)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if !self.Owner:IsNPC() then
		self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0))
		if SERVER then self.Owner:LagCompensation(true) end
	end
	
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * cvar_maxdist:GetInt()
	trace.filter = self.Owner
		local tr = util.TraceLine(trace)
		
	if IsFirstTimePredicted() and self.Owner:WaterLevel() < 3 then
		local beameffect = EffectData()
		beameffect:SetEntity(self)
		beameffect:SetOrigin(tr.HitPos)
		beameffect:SetAttachment(1)
		util.Effect("q1_lightning", beameffect)
	end

	if SERVER then 
		if tr.HitNonWorld then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(self.Primary.Damage)
			dmginfo:SetDamageType(DMG_SHOCK)
			dmginfo:SetAttacker(self.Owner)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageForce(self.Owner:GetUp() * 3500 + self.Owner:GetForward() * 20000)
			tr.Entity:TakeDamageInfo(dmginfo)
		end

		if self.Owner:WaterLevel() > 2 then
			self.Owner:TakeDamage(999, self.Owner)
		end
		
		if !self.Owner:IsNPC() then self.Owner:LagCompensation(false) end
	end
end

function SWEP:SpecialThink()
	if self:GetAttack() and (self.Owner:KeyReleased(IN_ATTACK) or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
		if self.firesound then self.firesound:Stop() end
		self:SetAttack(nil)
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_light.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_light.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/lstart.wav")
SWEP.Primary.LoopSound		= Sound("weapons/q1/lhit.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .1
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_cells"
SWEP.Primary.AmmoFallback	= "GaussEnergy"

SWEP.LightUp				= -15