AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/projectiles/quake1/missile.mdl")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(), Vector())
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
end

function ENT:SetDamage(dmg, rad)
    self.Damage = dmg
    self.Radius = rad
end

function ENT:Explode(pos, norm)
    pos = pos or self:GetPos()
    norm = norm or Vector()

    local effectdata = EffectData()
    effectdata:SetOrigin(pos + norm)
    effectdata:SetNormal(norm)
    util.Effect("q1_exp", effectdata)

    local owner = IsValid(self.Owner) and self.Owner or self
    
    -- Set up damage info
    local dmg = DamageInfo()
    dmg:SetInflictor(self)
    dmg:SetAttacker(owner)
    dmg:SetDamage(self.Damage or 100)
    dmg:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT))

    -- Reduce Damage To Self.
    if IsValid(owner) and owner:IsPlayer() then
        owner.IsQuakeRocketJumping = true
    end

    -- Deal standard splash damage to enemies/NPCs
    util.BlastDamageInfo(dmg, pos, self.Radius or 190)

    --removed tag to avoid weakening rocket launcher after rocket jumps.
    if IsValid(owner) and owner:IsPlayer() then
        owner.IsQuakeRocketJumping = nil
    end

    -- jump physics start
    local blastRadius = self.Radius or 190
    local pushForce = 450 -- decide is the rocket jump is useless, or rocketing into the stratosphere
    
    if IsValid(owner) and owner:IsPlayer() and owner:Alive() then
        -- Calculate distance between the explosion and the player
        local dist = owner:GetPos():Distance(pos)
        
        if dist <= blastRadius then
            -- Target slightly above feet so velocity points upward and outward
            local targetPos = owner:GetPos() + Vector(0, 0, 28)
            local dir = targetPos - pos
            dir:Normalize()

            -- Falloff calculation: Closer to explosion = faster launch
            local intensity = (blastRadius - dist) / blastRadius
            local velocity = dir * pushForce * intensity

            -- Apply velocity directly to the player
            owner:SetVelocity(velocity)
        end
    end
    -- jump physics end
    
    local snd = "weapons/q1/r_exp3.wav"
    if q1_cvar_hqsnds:GetBool() then
        snd = "weapons/q1_hq/r_exp3.wav"
    end
    self:EmitSound(snd, 100, math.random(95,105))
    self:Remove()
end

function ENT:Touch(ent)
    if !ent:IsSolid() then return end

    if self.didHit then return end
    self.didHit = true
    
    local tr = self:GetTouchTrace()
    
    local start = tr.HitPos - tr.HitNormal
    local endpos = tr.HitPos + tr.HitNormal 
    if tr.HitWorld then
        util.Decal("Scorch", start, start)
    end

    self:Explode(tr.HitPos, tr.HitNormal)
end

-----------------------------------------------------------------
-- GLOBAL JUMP DAMAGE SCALER HOOK
-----------------------------------------------------------------
hook.Add("EntityTakeDamage", "QuakeRocketJumpSelfDamageScaler", function(target, dmginfo)
    -- If the target player has our active jump tag, intercept and scale the damage down
    if IsValid(target) and target:IsPlayer() and target.IsQuakeRocketJumping then
        dmginfo:ScaleDamage(0.5)
    end
end)