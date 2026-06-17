if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Shotgun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/shot_icon")
	
	killicon.Add("weapon_q1_shotgun", "weapons/shot_icon", Color(255, 80, 0, 255))
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(0) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireLight()	
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self:WeaponSound()
	self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	self:TakeAmmo(1)
	self:SuperDamageSound()
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_shot.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_shot.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/guncock.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/guncock.wav")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 4
SWEP.Primary.NumShots		= 6
SWEP.Primary.Cone			= .05
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .5
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_shells"
SWEP.Primary.AmmoFallback	= "Buckshot"

SWEP.LightUp				= -15