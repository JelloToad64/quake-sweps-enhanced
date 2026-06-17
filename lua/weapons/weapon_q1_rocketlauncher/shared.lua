if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Rocket Launcher"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 6
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/rock2_icon")
	killicon.Add("q1_rocket", "weapons/rock2_icon", Color(255, 80, 0, 255))
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(0) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireLight()
	self:TakeAmmo(1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self:WeaponSound()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		pos = pos +ang:Up() *-10
		local entRock = ents.Create("q1_rocket")
		entRock:SetAngles(ang)
		entRock:SetPos(pos)
		entRock:SetOwner(self.Owner)
		entRock:SetDamage(math.random(100,120), self.Primary.Radius) //damage & radius
		entRock:SetVelocity(ang:Forward() * 1200) //projectile speed
		entRock:Spawn()
	end
	self:SuperDamageSound()
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_rock2.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_rock2.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/sgun1.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/sgun1.wav")
SWEP.Primary.Radius			= 190
SWEP.Primary.Recoil			= 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .8
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_rockets"
SWEP.Primary.AmmoFallback	= "RPG_Round"

SWEP.LightUp				= -15