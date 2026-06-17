if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Axe"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/axe_icon")
	
	killicon.Add("weapon_q1_axe", "weapons/axe_icon", Color(255, 80, 0, 255))
	
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound(self.Primary.Special, 75, nil, self.Primary.SpecialHQ)
	self.attackdelay = CurTime() +.25
	self:SuperDamageSound()
end

function SWEP:SpecialThink()
	if self.attackdelay and CurTime() > self.attackdelay then
		self.attackdelay = nil
		self:Melee()
	end
end

function SWEP:Melee()
	if SERVER then self.Owner:LagCompensation(true) end
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
		filter = self.Owner
	})

	if !IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
			filter = self.Owner,
			mins = Vector(-1, -1, -1),
			maxs = Vector(1, 1, 1)
		})
	end
	
	if tr.Hit then
		self:ImpactEffect(tr)
		if SERVER then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			if !IsValid(attacker) then attacker = self end
			dmginfo:SetAttacker(attacker)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.Primary.Damage)
			dmginfo:SetDamageForce(self.Owner:GetUp() *4000 +self.Owner:GetForward() *15000)
			tr.Entity:TakeDamageInfo(dmginfo)
		end
	end

	if tr.HitWorld then
		self:WeaponSound(self.Primary.Sound, 80)
	end
	if SERVER then self.Owner:LagCompensation(false) end
end

function SWEP:ImpactEffect(tr)
	if cvars.Bool("q1_sv_impactparticles") and !tr.HitSky then
		self:ImpactParticles(tr)
	else
		if !IsFirstTimePredicted() then return end
		local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetStart(tr.StartPos)
		e:SetSurfaceProp(tr.SurfaceProps)
		e:SetDamageType(DMG_BULLET)
		e:SetHitBox(tr.HitBox)
		if CLIENT then
			e:SetEntity(tr.Entity)
		else
			e:SetEntIndex(tr.Entity:EntIndex())
		end
		util.Effect("Impact", e)
	end
end

SWEP.HoldType			= "melee"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"

SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_axe.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_axe.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/axhit2.wav")
SWEP.Primary.Special		= Sound("weapons/q1/ax1.wav")
SWEP.Primary.SpecialHQ		= Sound("weapons/q1_hq/ax1.wav")
SWEP.Primary.Damage			= 20
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .5
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.HitDist				= 80