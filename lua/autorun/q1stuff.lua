-- NPC weapons

local npcWeps = {
	["weapon_q1_shotgun"] = "Shotgun",
	["weapon_q1_supershotgun"] = "Super Shotgun",
	["weapon_q1_nailgun"] = "Nailgun",
	["weapon_q1_supernailgun"] = "Super Nailgun",
	["weapon_q1_grenadelauncher"] = "Grenade Launcher",
	["weapon_q1_rocketlauncher"] = "Rocket Launcher",
	["weapon_q1_lightninggun"] = "Thunderbolt"
}

for cl, name in pairs(npcWeps) do
	list.Add("NPCUsableWeapons", {class = cl, title = "Quake "..name})
end

-- ammo

local ammo = {
	{"Nails", "quake_nails", 200, DMG_BULLET},
	{"Shells", "quake_shells", 100, DMG_BUCKSHOT},
	{"Rockets", "quake_rockets", 50, DMG_BLAST},
	{"Cells", "quake_cells", 100, DMG_SHOCK},
	{"Lava Nails", "quake_lavanails", 200, DMG_BULLET},
	{"Multi Rockets", "quake_multirockets", 50, DMG_BLAST},
	{"Plasma Cells", "quake_plasma", 100, DMG_SHOCK}	
}

for _, v in pairs(ammo) do
	game.AddAmmoType({name = v[2], maxcarry = v[3], dmgtype = v[4]})
	if CLIENT then language.Add(v[2].."_ammo", v[1]) end
end

-- player sounds

local quakeguy = "models/player/quakeguy.mdl"
player_manager.AddValidModel("quakeguy", quakeguy)

local q1_cvar_playersounds = CreateConVar("q1_sv_playersounds", 1, FCVAR_ARCHIVE, "If the Quakeguy playermodel is selected, enable Quake player sounds")

if CLIENT then return end

local function IsPlayerSoundsEnabled(ply)
	return q1_cvar_playersounds:GetBool() and ply:GetModel() == quakeguy
end

hook.Add("PlayerHurt", "QuakePlayerHurt", function(ply, attacker)
	if IsPlayerSoundsEnabled(ply) and !attacker:IsWorld() and ply:Health() > 0 then
		if !ply.SoundDelay then
			ply.SoundDelay = CurTime()
		end

		if ply.SoundDelay and ply.SoundDelay <= CurTime() then	
			if ply:WaterLevel() == 3 then
				ply:EmitSound("Player_Quake1.drown")
			else
				ply:EmitSound("Player_Quake1.pain")
			end
			ply.SoundDelay = CurTime() + 0.5
		end
	end
end)

hook.Add("EntityTakeDamage", "QuakeFallSound", function(ply, dmginfo)
	if ply:IsPlayer() and IsPlayerSoundsEnabled(ply) and ply:Health() - dmginfo:GetDamage() > 0 and dmginfo:IsFallDamage() then
		ply:EmitSound("Player_Quake1.land2")
	end
end)

hook.Add("PlayerDeath", "QuakeDeathSound", function(ply)
	if IsPlayerSoundsEnabled(ply) then
		ply:EmitSound("player/q1/death"..math.random(1,5)..".wav", 80, 100)
	end
end)

hook.Add("SetupMove", "QuakeJumpSound", function(ply, move)
	if !IsPlayerSoundsEnabled(ply) then return end
	if bit.band(move:GetButtons(), IN_JUMP) ~= 0 and bit.band(move:GetOldButtons(), IN_JUMP) == 0 and ply:OnGround() and ply:WaterLevel() < 2 and ply:Alive() and !ply:InVehicle() then
		if !ply.JumpSoundDelay then
			ply.JumpSoundDelay = CurTime()
		end

		if ply.JumpSoundDelay and ply.JumpSoundDelay <= CurTime() then
			ply:EmitSound("Player_Quake1.jump")
			ply.JumpSoundDelay = CurTime() + .2
		end
	end
end)

hook.Add("OnPlayerHitGround", "QuakeLanding", function(ply, inwater, floater, vel)
	if IsPlayerSoundsEnabled(ply) and ply:Health() > 0 then
		if !inwater and vel > 270 and vel < 700 then
			ply:EmitSound("Player_Quake1.land")
		end
	end
end)