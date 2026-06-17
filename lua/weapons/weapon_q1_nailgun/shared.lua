if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Nailgun"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/nail_icon")
	killicon.Add( "weapon_q1_nailgun", "weapons/nail_icon", Color( 255, 80, 0, 255 ) )
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(0) then return end
	self:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self:FireLight()
	self:TakeAmmo(1)
	self:WeaponSound()
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector():Angle()

	if !self:GetLeft() then
		self:SetLeft(true)
		pos = pos +ang:Right() *5 +ang:Up() *-10
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	else
		self:SetLeft(false)
		pos = pos +ang:Right() *-5 +ang:Up() *-10
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2)
	end

	if SERVER then
		local ent = ents.Create("q1_nail")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetOwner(self.Owner)
		ent:SetDamage(self.Primary.Damage)
		ent:SetVelocity(ang:Forward() * 2000)
		ent:Spawn()
	end
	self:SuperDamageSound()
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_nail.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_nail.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/rocket1i.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/rocket1i.wav")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 9
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .1
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_nails"
SWEP.Primary.AmmoFallback	= "XBowBolt"

SWEP.LightUp				= -22