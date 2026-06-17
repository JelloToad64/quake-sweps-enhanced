if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Super Shotgun"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/shot2_icon")
	
	killicon.Add("weapon_q1_supershotgun", "weapons/shot2_icon", Color(255, 80, 0, 255))
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(1) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireLight()	
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:WeaponSound()
	self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	self:TakeAmmo(2)
	self:SuperDamageSound()
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_shot2.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_shot2.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/shotgn2.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/shotgn2.wav")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 4
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= .16
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .7
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_shells"
SWEP.Primary.AmmoFallback	= "Buckshot"

SWEP.LightUp				= -15