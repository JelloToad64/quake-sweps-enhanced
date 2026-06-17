if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Super Nailgun"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/nail2_icon")
	killicon.Add( "weapon_q1_supernailgun", "weapons/nail2_icon", Color( 255, 80, 0, 255 ) )
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(1) then return end
	self:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self:FireLight()
	self:TakeAmmo(2)
	self:WeaponSound()
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		pos = pos +ang:Up() *-10
		local ent = ents.Create("q1_nail")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetOwner(self.Owner)
		ent:SetDamage(self.Primary.Damage)
		ent:SetVelocity(ang:Forward() * 2000)
		ent:Spawn()
	end
	self:SuperDamageSound()
	if !self.Owner:IsNPC() and self:GetAnimDelay() <= CurTime() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetAnimDelay(CurTime() + self.Owner:GetViewModel():SequenceDuration() -.1)
	end
end

function SWEP:SpecialThink()
	if self.Owner:KeyReleased(IN_ATTACK) or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 1 then
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
end

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_nail2.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_nail2.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/spike2.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/spike2.wav")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 18
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .1
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_nails"
SWEP.Primary.AmmoFallback	= "XBowBolt"

SWEP.LightUp				= -15