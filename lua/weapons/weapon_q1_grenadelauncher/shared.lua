if SERVER then

	AddCSLuaFile("shared.lua")
	
else

	SWEP.PrintName			= "Grenade Launcher"			
	SWEP.Author				= "Upset"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.WepSelectIcon		= surface.GetTextureID("weapons/rock_icon")
	
end

function SWEP:Grenadel()
	if SERVER then
		local ent = ents.Create("q1_grenade")
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		local random = math.Rand(0,1)
		local crandom = math.Rand(2*random, -0.5)
		local impulse = ang:Forward()*600 + ang:Up() * 200 + crandom*ang:Right()*10 + crandom*ang:Up()*10
		pos = pos +ang:Up() *-20
		ent:SetPos(pos)
		ent:SetAngles(ang +Angle(45,70,90))
		ent:SetOwner(self.Owner)
		ent:SetExplodeDelay(2.5)
		ent:SetDamage(self.Primary.Damage, self.Primary.Radius)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(impulse)
		end
	end
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack(0) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireLight()	
	self:WeaponSound()
	self:Grenadel()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:TakeAmmo(1)
	if !self.Owner:IsNPC() then self.Owner:SetViewPunchAngles(Angle(-self.Primary.Recoil, 0, 0)) end
	self:SuperDamageSound()
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_q1_base"
SWEP.Category			= "Quake 1"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_q1_rock.mdl"
SWEP.WorldModel			= "models/weapons/w_q1_rock.mdl"

SWEP.Primary.Sound			= Sound("weapons/q1/grenade.wav")
SWEP.Primary.SoundHQ		= Sound("weapons/q1_hq/grenade.wav")
SWEP.Primary.Damage			= 120
SWEP.Primary.Radius			= 160
SWEP.Primary.Recoil			= 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= .6
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "quake_rockets"
SWEP.Primary.AmmoFallback	= "RPG_Round"

SWEP.LightUp				= -10